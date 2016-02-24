//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by inailuy on 2/18/16.
//
//

import Foundation
import AVFoundation
import UIKit

class RecordSoundsVC: UIViewController {
    
    let startRecording = "Tap to Record"
    let recording = "Recording..."
    
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        recordingLabel.text = startRecording
        resumeButton.hidden = true
        stopButton.hidden = true
        stopButton.enabled = true
    }
    
    @IBAction func microphoneButtonPressed(sender: UIButton) {
        if AVAudioSession.sharedInstance().inputAvailable {
            AudioManager.sharedInstance.startRecording()
            
            recordingLabel.text = recording
            stopButton.hidden = false
            resumeButton.hidden = false
            sender.enabled = false
        }
    }
    
    @IBAction func pausedButtonPressed(sender: UIButton) {
        sender.selected = !sender.selected
        AudioManager.sharedInstance.pauseRecording(sender.selected)
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        microphoneButton.enabled = true
        stopButton.hidden = true
        resumeButton.hidden = true
        
        recordingLabel.text = startRecording
        AudioManager.sharedInstance.stopRecording()
        stopButton.enabled = false
    }
}