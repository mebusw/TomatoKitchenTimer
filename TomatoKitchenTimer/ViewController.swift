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
 add progress bar. when it's less than 10%, then start to blink and keep at 5%
 keyin cooldown
 choose music
 */

class ViewController: NSViewController, NSControlTextEditingDelegate {
    enum KEY: UInt16 {
        case A = 0
        case S = 1
        case D = 2
        case F = 3
        case G = 5
        case Z = 6
        case X = 7
        case C = 8
        case V = 9
        case ENTER = 36
        case SPACE = 49
        case ESC = 53
        case BACKSPACE = 51
    }

    @IBOutlet var countDownText:NSTextFieldCell?
    @IBOutlet var targetText:NSTextFieldCell?
    @IBOutlet var startStopBtn:NSButton?
    @IBOutlet var progressIndicator:NSProgressIndicator?
    var timerCore = TimerCore()
    var beepPlayer:AVAudioPlayer?   /** AVAudioPlayer must be a class-level variable */
    
    // http://stackoverflow.com/questions/28012566/swift-osx-key-event
    let keyCodeToNumberMapping:[UInt16:Int] = [18:1, 19:2, 20:3, 21:4, 23:5, 22:6, 26:7, 28:8, 25:9, 29:0]
    
    let KeyCodeToMinuteMapping:[KEY:Int] = [.A:1, .S:2, .D:3, .F:4, .G:5, .Z:8, .X:10, .C:15, .V:20]
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.title = "Tomato Kitchen Timer"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
//        let btnFor1Min:NSButton = NSButton(title: "2m", target: self, action: #selector(self.shortcutPressed(_:)))
//        btnFor1Min.frame = CGRect(x: 200, y: 30, width: 100, height: 30)
//        view.addSubview(btnFor1Min)
    }
    
    @objc func shortcutPressed(_ sender: NSButton) {
        print(sender)
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
                self.countDownText?.title = self.timerCore.secToDisplayable(self.timerCore.targetSeconds)
                self.progressIndicator?.doubleValue = 100
            },
            stopCallback: {
                //self.startStopBtn?.title = "Start"
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStart", ofType: "png")!))
            },
            timeUpCallback: {
                //self.startStopBtn?.title = "Start"
                self.startStopBtn?.image = NSImage(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "PicButtonStart", ofType: "png")!))
                self.playSoundClip()
            },
            tickCallback: {
                self.countDownText?.title = self.timerCore.secToDisplayable(self.timerCore.countDownSeconds)
                self.progressIndicator?.doubleValue = Double(self.timerCore.countDownSeconds) / Double( self.timerCore.targetSeconds) * 100
            })
        
    }


    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
        print(event.keyCode)

        switch event.keyCode {
        case KEY.ENTER.rawValue:
            toogleStartStop(self)
        case KEY.BACKSPACE.rawValue:
            timerCore.delByBackSpace()
            targetText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
        case 18,19,20,21,23,22,26,28,25,29:
            timerCore.put(keyCodeToNumber(event.keyCode))
            targetText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
        case 0,1,2,3,5,6,7,8,9:
            timerCore.targetSeconds = 60 * KeyCodeToMinuteMapping[KEY(rawValue: UInt16(event.keyCode))!]!
            targetText?.title = timerCore.secToDisplayable(timerCore.targetSeconds)
            timerCore.isRunning = true
            toogleStartStop(self)
            toogleStartStop(self)
        default:
            print("other keys, \(event.keyCode)")
        }
    }
    
    fileprivate func keyCodeToNumber(_ keyCode: UInt16) -> Int {
        return keyCodeToNumberMapping[keyCode]!
    }
}

