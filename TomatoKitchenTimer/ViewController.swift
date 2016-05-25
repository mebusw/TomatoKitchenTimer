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

    @IBOutlet var countDownText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
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
        timerCore.tick()
        
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .LongStyle)
        print(timestamp)
        
        timerCore.targetSeconds -= 1
        
        countDownText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
        
        
        //TODO extract a stop method and reset targetText
        if timerCore.targetSeconds <= 0 {
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
            timerCore.start(#selector(self.startCB))
            startStopBtn?.title = "Stop"
            countDownText?.title = (targetText?.title)!
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.tick(_:)), userInfo: nil, repeats: true)
        } else {
            timerCore.stop()
            startStopBtn?.title = "Start"
            timer?.invalidate()
            countDownText?.title = "00:00:00"
        }
        
        timerCore.isRunning = !timerCore.isRunning
    }
    
    func startCB() {
        print("start callback")
    }
    
    override func keyDown(event: NSEvent) {
        super.keyDown(event)

        switch event.keyCode {
        case 36:
            toogleStartStop(self)
            print("toogle")
        case 18,19,20,21,23,22,26,28,25,29:
            timerCore.put(keyCodeToNumber(event.keyCode))
            
            targetText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
        default:
            print("other keys, \(event.keyCode)")
        }
    }
    
    func keyCodeToNumber(keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

