//
//  AudioManager.swift
//  Pitch Perfect
//
//  Created by inailuy on 2/19/16.
//
//

import Foundation
import AVFoundation

class AudioManager : NSObject, AVAudioRecorderDelegate{
    //MARK: Vars
    static let sharedInstance = AudioManager()
    let recordSettings :[String : AnyObject] = [
        AVFormatIDKey:Int(kAudioFormatAppleIMA4),
        AVSampleRateKey:44100.0,
        AVNumberOfChannelsKey:2,
        AVEncoderBitRateKey:12800,
        AVLinearPCMBitDepthKey:16,
        AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
    ]
    let fastTag = 100
    let slowTag = 101
    let chipmunkTag = 102
    let darthvaderTag = 103
    let reverbTag = 104
    let echoTag = 105
    var audioRecorder : AVAudioRecorder!
    var audioEngine : AVAudioEngine!
    var audioPlayer : AVAudioPlayer!
    var filePathUrl : NSURL!
    var audioPlayerNode : AVAudioPlayerNode!
    
    override init() {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        filePathUrl = documentDirectory.URLByAppendingPathComponent("audio.caf")
        
        try! audioRecorder = AVAudioRecorder(URL: filePathUrl!, settings: recordSettings)
    }
    //MARK: Recording Related
    func startRecording(){
        audioRecorder?.delegate = self
        audioRecorder?.prepareToRecord()
        audioRecorder?.record()
    }
    
    func pauseRecording(withBool:Bool){
        if withBool {
                audioRecorder.pause()
        }else{
                startRecording()
        }
    }
    
    func stopRecording(){
        if ((audioRecorder?.recording) != nil){
            audioRecorder?.stop()
        }
    }
    
    func playRecording(withTag:Int){
        if audioEngine == nil {
            audioEngine = AVAudioEngine()
        }
        try! audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl)
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        // Filter each mode
        switch withTag {
        case chipmunkTag :
            highPitchMode()
        case fastTag :
            fastMode()
        case slowTag :
            slowMode()
        case darthvaderTag :
            lowPitchMode()
        case reverbTag :
            reverbMode()
        case echoTag :
            echoMode()
        default :
            break
        }
        
        try! audioEngine.start()
        audioPlayerNode.play()
    }
    
    func stopPlayingRecording(){
        AudioManager.sharedInstance.audioPlayer.stop()
        AudioManager.sharedInstance.audioEngine.stop()
    }
    
    //MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            filePathUrl = recorder.url
        }
    }
    //MARK: Sound Motifications Actions
    func highPitchMode(){
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = 1000
        playAudioWithVariablePith(pitchEffect)
    }
    
    func lowPitchMode(){
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.pitch = -1000
        playAudioWithVariablePith(pitchEffect)
    }
    
    func fastMode(){
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.rate = 2.5
        playAudioWithVariablePith(pitchEffect)
    }
    
    func slowMode(){
        let pitchEffect = AVAudioUnitTimePitch()
        pitchEffect.rate = 0.5
        playAudioWithVariablePith(pitchEffect)
    }
    
    func echoMode(){
        let echoNode = AVAudioUnitDelay()
        
        echoNode.delayTime = NSTimeInterval(0.3)
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        self.playAudioNode(echoNode)
    }
    
    func reverbMode(){
        let reverbNode = AVAudioUnitReverb()
        audioPlayerNode = AVAudioPlayerNode()
        
        audioEngine.attachNode(audioPlayerNode)
        reverbNode.loadFactoryPreset( AVAudioUnitReverbPreset.Cathedral)
        reverbNode.wetDryMix = 60
        audioEngine.stop()
        
        self.playAudioNode(reverbNode)
    }
    //MARK: Sound Motifications Helper
    func playAudioNode(node: AVAudioUnitEffect){
        let audioFile = try! AVAudioFile(forReading: filePathUrl)
        
        audioEngine.attachNode(node)
        audioEngine.connect(audioPlayerNode, to: node, format: audioFile.processingFormat)
        audioEngine.connect(node, to: audioEngine.outputNode, format: audioFile.processingFormat)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler:nil)
    }
    
    func playAudioWithVariablePith(changePitchEffect:AVAudioUnitTimePitch){
        audioPlayerNode = AVAudioPlayerNode()
       
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(changePitchEffect)
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        let audioFile = try! AVAudioFile(forReading: filePathUrl)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
    }
}