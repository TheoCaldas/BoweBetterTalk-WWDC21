//
//  MicDetection.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import Foundation
import AVFoundation

protocol MicDelegate{
    func receiveSignal()
}

class MicDetection {
    //OBS: NAO ESQUECER de adicionar a categoria (Privacy - Microphone Usage Description) na info.plist

    private var recorder: AVAudioRecorder!
    private var levelTimer = Timer()
    private var LEVEL_THRESHOLD: Float = 15.0
        
    var delegate: MicDelegate?
    
    init(delegate: MicDelegate, volumeThreshold: Float?){
        self.delegate = delegate
        if let newThreshold = volumeThreshold{
            self.LEVEL_THRESHOLD = newThreshold
        }
    }
    
    
    /// Configures the mic internal properties and request permission for it's usage (only call it once)
    public func settupRecorder(){
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")

        let recordSettings: [String: Any] = [
                    AVFormatIDKey:              kAudioFormatAppleIMA4,
                    AVSampleRateKey:            44100.0,
                    AVNumberOfChannelsKey:      1,
                    AVEncoderBitRateKey:        12800,
                    AVLinearPCMBitDepthKey:     16,
                    AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
                ]
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord) //request permission
            try audioSession.setActive(true)
        
            try self.recorder = AVAudioRecorder(url:url, settings: recordSettings)
        }
        catch {
            print("Error settup recorder")
            return
        }
    }
    
    /// Starts capturing audio through recorder
    public func startRecorder(){
        self.recorder.prepareToRecord()
        self.recorder.isMeteringEnabled = true
        self.recorder.record()

        self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.levelTimerCallback), userInfo: nil, repeats: true)
    }

    /// Check if current volume is greater then threshold. If so, tell delegate.
    @objc func levelTimerCallback() {
        if !self.recorder.isRecording {return}
        
        self.recorder.updateMeters()

        let level = self.recorder.averagePower(forChannel: 0)
        let isLoud = level > -self.LEVEL_THRESHOLD

        if isLoud{
            //print("IsLoud!")
            self.delegate?.receiveSignal()
        }
        
    }
    
    /// Stops capturing audio through recorder
    public func stopRecorder(){
        self.recorder.stop()
        self.levelTimer = Timer()
    }
    
}
