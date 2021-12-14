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
    var seq:[Int] = [0, 0, 0, 0, 0, 0]
    var targetSeconds:Int = 0
    var countDownSeconds:Int = 0
    var timer:Timer?
    var timeUpCallback: () -> Void = {}
    var tickCallback: () -> Void = {}
    var startTime:Date?
    var log: String = ""

    override init() {
        super.init()
    }
    
    func toogleStartStop(startCallback: () -> Void = {}, stopCallback: () -> Void = {}, timeUpCallback: @escaping () -> Void = {}, tickCallback: @escaping () -> Void = {}) {
        self.timeUpCallback = timeUpCallback
        self.tickCallback = tickCallback
        
        if !isRunning {
            self.countDownSeconds = self.targetSeconds
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            startTime = Date()
            
            startCallback()
        } else {
            reset()
            stopCallback()
        }
        isRunning = !isRunning
    }
    
    @objc func tick(_ timer : Timer) {
        let interval:TimeInterval = Date().timeIntervalSince(startTime!)
        print(interval)
        print(Date())
        print(startTime ?? 0)
        self.log = String.init(format: "%f=====%s======%s\n", interval ,String(describing: startTime!), String(describing: Date()))
        countDownSeconds = targetSeconds - Int(interval)
        self.tickCallback()
        
        if countDownSeconds <= 0 {
            isRunning = false
            reset()
            self.timeUpCallback()
        }
        
    }
    
    fileprivate func reset() {
        countDownSeconds = 0
        timer?.invalidate()
    }
    
    fileprivate func caculateTargetSeconds() {
        var hour = seq[0] * 10 + seq[1]
        hour = hour > 23 ? 23 : hour
        var minute = seq[2] * 10 + seq[3]
        minute = minute > 59 ? 59 : minute
        var second = seq[4] * 10 + seq[5]
        second = second > 59 ? 59 : second
        
        targetSeconds = hour * 3600 + minute * 60 + second
    }
    
    func put(_ number:Int) {
        seq.remove(at: 0)
        seq.append(number)

        caculateTargetSeconds()
    }

    
    func secToDisplayable(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = (seconds - hour * 3600) / 60
        let second = seconds - hour * 3600 - minute * 60

        var displayable =  String(format: "%02d:%02d", minute, second)
        if hour > 0 {
            displayable = String(format: "%02d:%@", hour, displayable)
        }
        return displayable
    }
    
    func delByBackSpace()
    {
        if !isRunning {
            for index in (1...5).reversed() {
                seq[index] = seq[index - 1]
            }
            seq[0] = 0

            caculateTargetSeconds()
        }
    }
}
