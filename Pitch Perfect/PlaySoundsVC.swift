//
//  PlaySoundsVC.swift
//  Pitch Perfect
//
//  Created by inailuy on 2/18/16.
//
//

import Foundation
import UIKit
import AVFoundation

class PlaySoundsVC: UIViewController, AVAudioPlayerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        AudioManager.sharedInstance.audioPlayer.stop()
        AudioManager.sharedInstance.audioEngine.stop()
    }
    
    
    @IBAction func soundEffectButtonPressed(sender: UIButton) {
        AudioManager.sharedInstance.playRecording(sender.tag)
    }
}