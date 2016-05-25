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
    
    override init() {
        super.init()
    }
    
    func start(callback: Selector) {
        self.countDownSeconds = self.targetSeconds
        //callback.
    }
    
    func stop() {
        self.countDownSeconds = 0
    }
    
    func tick() {
        countDownSeconds -= 1
        
        if countDownSeconds <= 0 {
            isRunning = false
        }
        
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
