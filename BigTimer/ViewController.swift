//
//  ViewController.swift
//  BigTimer
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var timeText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    var isRunning:Bool = false
    var targetSeconds:Int = 0
    var timer:NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func tick(timer : NSTimer) {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .LongStyle)
        print(timestamp)
        //print(timer.userInfo)
        targetSeconds -= 1
        print(targetSeconds)
        timeText?.title = String(format: ":%d", targetSeconds)
        if targetSeconds <= 0 {
            timer.invalidate()
        }
        
    }

    @IBAction func toogleStartStop(sender:NSObject) {
        if !isRunning {
            startStopBtn?.title = "Stop"
            targetSeconds = Int((targetText?.title)!)!
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
        } else {
            startStopBtn?.title = "Start"
            timer?.invalidate()
        }
        
        isRunning = !isRunning
    }

}

