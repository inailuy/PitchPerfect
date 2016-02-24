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

class PlaySoundsVC: UIViewController {

    @IBAction func stopButtonPressed(sender: UIButton) {
        AudioManager.sharedInstance.stopPlayingRecording()
    }
    
    
    @IBAction func soundEffectButtonPressed(sender: UIButton) {
        AudioManager.sharedInstance.playRecording(sender.tag)
    }
}