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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func tick(timer : NSTimer) {
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .LongStyle)
        print(timestamp)
        print(timer.userInfo)
        timeText?.title = timestamp
    }


}

