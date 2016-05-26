//
//  ViewController.swift
//  BigTimer
//
//  Created by JackyShen on 16/5/24.
//  Copyright © 2016年 JackyShen. All rights reserved.
//

import Cocoa
import AVFoundation

/* TODO: 
 keyin cooldown
 choose music
 animation
 */

class ViewController: NSViewController, NSControlTextEditingDelegate {

    @IBOutlet var countDownText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    var timerCore = TimerCore()
    var beepPlayer:AVAudioPlayer?   /** AVAudioPlayer must be a class-level variable */
    
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
            timerCore.start({
                    print("start callback")
                    self.startStopBtn?.title = "Stop"
                    self.countDownText?.title = self.timerCore.secToDisplayable(self.timerCore.targetSeconds)
                },
                timeUpCallback: {
                    print("timeup callback")
                    self.startStopBtn?.title = "Start"
                    self.playSoundClip()

                },
                tickCallback: {
                    print("tick callback")
                    self.countDownText?.title = self.timerCore.secToDisplayable(self.timerCore.countDownSeconds)
                }
            )
        } else {
            timerCore.stop() {
                print("stop callback")
                self.startStopBtn?.title = "Start"
                self.countDownText?.title = self.timerCore.secToDisplayable(self.timerCore.countDownSeconds)
            }
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
            
            targetText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
        default:
            print("other keys, \(event.keyCode)")
        }
    }
    
    func keyCodeToNumber(keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

