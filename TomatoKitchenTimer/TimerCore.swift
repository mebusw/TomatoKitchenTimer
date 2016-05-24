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
        let hour = seq[0] * 10 + seq[1]
        let minute = seq[2] * 10 + seq[3]
        let second = seq[4] * 10 + seq[5]
        return [hour, minute, second, hour * 3600 + minute * 60 + second]
    }
}
