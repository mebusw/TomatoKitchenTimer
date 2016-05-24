//
//  TimerCore.swift
//  TomatoKitchenTimer
//
//  Created by JackyShen on 16/5/25.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa


class TimerCore: NSObject {
    var seq:[Int] = [0, 0, 0, 0, 0, 0]
    
    override init() {
        super.init()
    }
    
    func put(number:Int) {
        seq.removeAtIndex(0)
        seq.append(number)
    }
    
    func generate() -> [Int] {
        var hour = seq[0] * 10 + seq[1]
        hour = hour > 23 ? 23 : hour
        var minute = seq[2] * 10 + seq[3]
        minute = minute > 59 ? 59 : minute
        var second = seq[4] * 10 + seq[5]
        second = second > 59 ? 59 : second
        return [hour, minute, second, hour * 3600 + minute * 60 + second]
    }
}
