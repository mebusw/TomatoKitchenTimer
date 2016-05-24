//
//  ViewController.swift
//  BigTimer
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSControlTextEditingDelegate {

    @IBOutlet var timeText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    var isRunning:Bool = false
    var targetSeconds:Int = 0
    var timer:NSTimer?
    var keySequence:[Int] = []
    
    // http://stackoverflow.com/questions/28012566/swift-osx-key-event
    let keyCodeToNumberMapping:[UInt16:Int] = [18:1, 19:2, 20:3, 21:4, 23:5, 22:6, 26:7, 28:8, 25:9, 29:0]
    
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
        timeText?.title = String(format: "00:00:%02d", targetSeconds)
        if targetSeconds <= 0 {
            timer.invalidate()
            isRunning = false
            startStopBtn?.title = "Start"
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
            timeText?.title = "00:00:00"
        }
        
        isRunning = !isRunning
    }
    
    func control(control: NSControl, textShouldEndEditing fieldEditor: NSText) -> Bool {
        print(targetText?.title)
        toogleStartStop(self)
        return true
    }
    
    override func keyDown(event: NSEvent) {
        super.keyDown(event)
        print("Caught a key down: \(event.keyCode)!")
        switch event.keyCode {
        case 36:
            toogleStartStop(self)
            print("toogle")
        case 18,19,20,21,23,22,26,28,25,29:
            keySequence.append(keyCodeToNumber(event.keyCode))
            print("inputed 0-9 => \(keySequence)")
        default:
            print("other keys")
        }
    }
    
    func keyCodeToNumber(keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

