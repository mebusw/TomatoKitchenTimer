//
//  TimerCore.swift
//  TomatoKitchenTimer
//
//  Created by JackyShen on 16/5/25.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa


class TimerCore: NSObject {
    var isRunning:Bool = false
    var isEscaping:Bool = false
    var seq6:[Int] = [0, 0, 0, 0, 0, 0]
    var seq4:[Int] = [0, 0, 0, 0]
    var targetSeconds:Int = 0
    var countDownSeconds:Int = 0
    var timer:Timer?
    var timeUpCallback: () -> Void = {}
    var tickCallback: () -> Void = {}
    var escCallback: () -> Void = {}
    var startTime:Date?
    var log: String = ""

    override init() {
        super.init()
        
    }
    
    func toogleStartStop(startCallback: () -> Void = {}, stopCallback: () -> Void = {}, escCallback: () -> Void = {}, timeUpCallback: @escaping () -> Void = {}, tickCallback: @escaping () -> Void = {}) {
        self.timeUpCallback = timeUpCallback
        self.tickCallback = tickCallback
        
        if isEscaping {
            resetAll()
            escCallback()
            isEscaping = false
            isRunning = false

        } else {
        
            if !isRunning {
                self.countDownSeconds = self.targetSeconds
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
                RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
                startTime = Date()
                
                startCallback()
            } else {
                resetCountDown()
                stopCallback()
            }
            isRunning = !isRunning
        }
    }
    
    @objc func tick(_ timer : Timer) {
        let interval:TimeInterval = Date().timeIntervalSince(startTime!)
  
        countDownSeconds = targetSeconds - Int(interval)
        self.tickCallback()
        
        if countDownSeconds <= 0 {
            isRunning = false
            resetCountDown()
            self.timeUpCallback()
        }
        
    }
    
    fileprivate func resetCountDown() {
        countDownSeconds = 0
        timer?.invalidate()
    }
    
    fileprivate func resetAll() {
        countDownSeconds = 0
        targetSeconds = 0
        seq4 = [0, 0, 0, 0]
        
        timer?.invalidate()
    }

//    可以设置小时、分钟、秒
    func putHMS(_ number:Int) {
        seq6.remove(at: 0)
        seq6.append(number)

        var hour = seq6[0] * 10 + seq6[1]
        hour = hour > 23 ? 23 : hour
        var minute = seq6[2] * 10 + seq6[3]
        minute = minute > 59 ? 59 : minute
        var second = seq6[4] * 10 + seq6[5]
        second = second > 59 ? 59 : second

        targetSeconds = hour * 3600 + minute * 60 + second
    }
    

    fileprivate func caculateTargetSeconds() {
        var minute = seq4[0] * 10 + seq4[1]
        minute = minute > 59 ? 59 : minute
        var second = seq4[2] * 10 + seq4[3]
        second = second > 59 ? 59 : second
        
        targetSeconds = minute * 60 + second
    }
    
    // 只需要设置分钟和秒
    func putMS(_ number:Int) {
        seq4.remove(at: 0)
        seq4.append(number)

        caculateTargetSeconds()
    }
    
    func delByBackSpace()
    {
        if !isRunning {
            for index in (1...3).reversed() {
                seq4[index] = seq4[index - 1]
            }
            seq4[0] = 0
            
            caculateTargetSeconds()
        }
    }

    //显示小时分钟秒
    func secToDisplayableHMS(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = (seconds - hour * 3600) / 60
        let second = seconds - hour * 3600 - minute * 60

        var displayable =  String(format: "%02d:%02d", minute, second)
        if hour > 0 {
            displayable = String(format: "%02d:%@", hour, displayable)
        }
        return displayable
    }
    
    //显示分钟秒
    func secToDisplayableMS(_ seconds: Int) -> String {
        
        let minute = seconds / 60
        let second = seconds - minute * 60

        let displayable =  String(format: "%02d:%02d", minute, second)
        
        return displayable
    }
    
    func setEscaping(_ isescaping: Bool)
    {
        self.isEscaping = isescaping
    }
}
