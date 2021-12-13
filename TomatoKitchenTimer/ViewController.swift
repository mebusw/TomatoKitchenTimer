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

    let KEY_ENTER:UInt16 = 36
    let KEY_SPACE:UInt16 = 49
    let KEY_ESC:UInt16 = 53
    let KEY_BACKSPACE:UInt16 = 51
    
    @IBOutlet var countDownText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    var timerCore = TimerCore()
    var beepPlayer:AVAudioPlayer?   /** AVAudioPlayer must be a class-level variable */
    @IBOutlet var logger:NSTextFieldCell?
    
    // http://stackoverflow.com/questions/28012566/swift-osx-key-event
    let keyCodeToNumberMapping:[UInt16:Int] = [18:1, 19:2, 20:3, 21:4, 23:5, 22:6, 26:7, 28:8, 25:9, 29:0]
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Scream Timer"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    
    func playSoundClip() {
        do {
            let beepSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Rooster", ofType: "mp3")!)
//            print(beepSound)
            beepPlayer = try AVAudioPlayer(contentsOf: beepSound)
            beepPlayer!.play()
        } catch {
            print("No sound found")
        }
    }

    @IBAction func toogleStartStop(_ sender:NSObject) {
        timerCore.toogleStartStop(
            startCallback: {
                //self.startStopBtn?.title = "Stop"
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStop", ofType: "png")!))
                self.countDownText?.title = self.timerCore.secToDisplayableMS(self.timerCore.targetSeconds)
            },
            stopCallback: {
                //self.startStopBtn?.title = "Start"
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStart", ofType: "png")!))
            },
            escCallback: {
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStart", ofType: "png")!))
                self.countDownText?.title = self.timerCore.secToDisplayableMS(self.timerCore.countDownSeconds)
                self.targetText?.title = self.timerCore.secToDisplayableMS(self.timerCore.countDownSeconds)
            },
            timeUpCallback: {
                //self.startStopBtn?.title = "Start"
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStart", ofType: "png")!))
                self.playSoundClip()
            },
            tickCallback: {
                self.countDownText?.title = self.timerCore.secToDisplayableMS(self.timerCore.countDownSeconds)
                self.logger?.title += self.timerCore.log
            }
        )
    }


    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        print(event.keyCode)

        switch event.keyCode {
        case KEY_ENTER,KEY_SPACE:
            toogleStartStop(self)
        case 18,19,20,21,23,22,26,28,25,29:
            timerCore.putMS(keyCodeToNumber(event.keyCode))
            targetText?.title = timerCore.secToDisplayableMS(timerCore.targetSeconds)
        case KEY_ESC:
            timerCore.setEscaping(true)
            toogleStartStop(self)
            targetText?.title = timerCore.secToDisplayableMS(timerCore.targetSeconds)
        case KEY_BACKSPACE:
            timerCore.delByBackSpace()
            targetText?.title = timerCore.secToDisplayableMS(timerCore.targetSeconds)
        default:
            print("other keys, \(event.keyCode)")
        }
    }
    
    fileprivate func keyCodeToNumber(_ keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

