//
//  ViewController.swift
//  BigTimer
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController, NSControlTextEditingDelegate {

    @IBOutlet var timeText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    var targetSeconds:Int = 0
    var timer:NSTimer?
    var timerCore = TimerCore()
    var beepPlayer:AVAudioPlayer?
    
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
        
        targetSeconds -= 1
        
        timeText?.title = timerCore.secToDisplayable(targetSeconds)
        
        
        //TODO extract a stop method and reset targetText
        if targetSeconds <= 0 {
            timer.invalidate()
            timerCore.isRunning = false
            startStopBtn?.title = "Start"
            playSoundClip()
        }
        
    }
    
    func playSoundClip() {
        do {
            let beepSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Gliss", ofType: "mp3")!)
            print(beepSound)
            beepPlayer = try AVAudioPlayer(contentsOfURL: beepSound)
            print(beepPlayer!.play())
        } catch {
            print("No sound found")
        }
    }

    @IBAction func toogleStartStop(sender:NSObject) {
        if !timerCore.isRunning {
            startStopBtn?.title = "Stop"
            timeText?.title = (targetText?.title)!
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.tick(_:)), userInfo: nil, repeats: true)
        } else {
            startStopBtn?.title = "Start"
            timer?.invalidate()
            timeText?.title = "00:00:00"
        }
        
        timerCore.isRunning = !timerCore.isRunning
    }
    
    override func keyDown(event: NSEvent) {
        super.keyDown(event)

        switch event.keyCode {
        case 36:
            toogleStartStop(self)
            print("toogle")
        case 18,19,20,21,23,22,26,28,25,29:
            timerCore.put(keyCodeToNumber(event.keyCode))
            let seq = timerCore.generate()
            targetText?.title = String(format: "%02d:%02d:%02d", seq[0], seq[1], seq[2])
            targetSeconds = seq[3]
        default:
            print("other keys, \(event.keyCode)")
        }
    }
    
    func keyCodeToNumber(keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

