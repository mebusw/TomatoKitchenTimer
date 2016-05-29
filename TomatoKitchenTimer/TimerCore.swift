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
    var timer:NSTimer?
    var timeUpCallback: () -> Void = {}
    var tickCallback: () -> Void = {}
    var startTime:NSDate?

    override init() {
        super.init()
    }
    
    func toogleStartStop(startCallback startCallback: () -> Void = {}, stopCallback: () -> Void = {}, timeUpCallback: () -> Void = {}, tickCallback: () -> Void = {}) {
        self.timeUpCallback = timeUpCallback
        self.tickCallback = tickCallback
        
        if !isRunning {
            self.countDownSeconds = self.targetSeconds
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
            startTime = NSDate()
            
            startCallback()
        } else {
            reset()
            stopCallback()
        }
        isRunning = !isRunning
    }
    
    func tick(timer : NSTimer) {
        let interval:NSTimeInterval = NSDate().timeIntervalSinceDate(startTime!)
        print(interval)
        countDownSeconds = targetSeconds - Int(interval)
        self.tickCallback()
        
        if countDownSeconds <= 0 {
            isRunning = false
            reset()
            self.timeUpCallback()
        }
        
    }
    
    private func reset() {
        countDownSeconds = 0
        timer?.invalidate()
    }
    
    func put(number:Int) {
        seq.removeAtIndex(0)
        seq.append(number)

        var hour = seq[0] * 10 + seq[1]
        hour = hour > 23 ? 23 : hour
        var minute = seq[2] * 10 + seq[3]
        minute = minute > 59 ? 59 : minute
        var second = seq[4] * 10 + seq[5]
        second = second > 59 ? 59 : second
    
        targetSeconds = hour * 3600 + minute * 60 + second
    }

    
    func secToDisplayable(seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = (seconds - hour * 3600) / 60
        let second = seconds - hour * 3600 - minute * 60
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
