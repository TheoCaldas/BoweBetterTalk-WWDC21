//
//  SoundManager.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 16/04/21.
//

import Foundation
import AVFoundation

public enum BackgroundMusic: String {
    case page1 = "minigame2 music 1.3.mp3"
    case page2 = "minigame3 music 1.0.mp3"
    case page3 = "page3 music 1.0.mp3"
}

public enum SFX: String, CaseIterable{
    //global
    case hint = "minigame2 Hint 1.0.mp3"
    case nextLevel = "minigame3 nextLevel 1.0.mp3"
    
    //minigame2
    case minigame2VoiceOver = "minigame2 VoiceOver 1.0.mp3"
    case boweScream = "minigame2 BoweScream 1.0.mp3"
    case boweHum = "minigame2 BoweHum 1.0.mp3"
    
    //minigame3
    case wallHit = "minigame3 wallHit 1.0.mp3"
    case wallFalling = "minigame3 wallFalling 1.0.mp3"
    case darwinNo = "minigame3 darwinNo 1.0.mp3"
    case darwinYes = "minigame3 darwinYes 1.0.mp3"
    case messageBlock = "minigame3 messageBlock 1.0.mp3"
    case messageClear = "minigame3 messageClear 1.0.mp3"
    case messageMess = "minigame3 messageMess 1.0.mp3"
    case minigame3VoiceOver1 = "minigame3 voiceOver1 1.0.mp3"
    case minigame3VoiceOver2 = "minigame3 voiceOver2 1.0.mp3"
}

public class SoundManager {
    
    //SFX
    private var sfxPlayerDict = [SFX: AVAudioPlayer?]()
    private var sfxVolume: Float = 1.0
    
    //Music
    private var currentBackgroundMusic: BackgroundMusic?
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var backgroundMusicVolume: Float = 1.0
    
    private static var singleInstance: SoundManager? = nil
    
    private init(){
        for sfx in SFX.allCases{
            sfxPlayerDict[sfx] = nil
        }
    }
    
    public static func sharedInstance() -> SoundManager {
        guard let instance = singleInstance else{
            let newInstance = SoundManager()
            singleInstance = newInstance
            return newInstance
        }
        return instance
    }
    
    public func playBackgroundMusic(_ song: BackgroundMusic, mustLoop: Bool) {
        
        //dont restart song if the song parameter is the same as the current song playing
        if let current = currentBackgroundMusic{
            if current == song{
                return
            }
        }
        
        let url = Bundle.main.url(forResource: song.rawValue, withExtension: nil)
        if (url == nil) {
            print("Could not find file: \(song)")
            return
        }
        
        var error: NSError? = nil
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url!)
        } catch let error1 as NSError {
            error = error1
            backgroundMusicPlayer = nil
        }
        if let player = backgroundMusicPlayer {
            player.volume = self.backgroundMusicVolume
            player.numberOfLoops = 0
            if mustLoop{
                player.numberOfLoops = -1
            }
            player.prepareToPlay()
            player.play()
        } else {
            print("Could not create audio player: \(error!)")
            return
        }
        
        //set the current song as the song playing
        currentBackgroundMusic = song
    }
    
    public func pauseBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if player.isPlaying {
                player.pause()
            }
        }
    }
    
    public func resumeBackgroundMusic() {
        if let player = backgroundMusicPlayer {
            if !player.isPlaying {
                player.play()
            }
        }
    }
    
    public func changeVolumeBackgroundMusic(volume: Float){
        self.backgroundMusicVolume = volume
        if let player = self.backgroundMusicPlayer {
            player.volume = self.backgroundMusicVolume
        } else {
            print("Could not open audio player!")
            return
        }
    }
    
    public func playSoundEffect(_ effect: SFX, mustLoop: Bool) {
        
        guard let audioPlayer = self.sfxPlayerDict[effect] as? AVAudioPlayer else{
            
            let url = Bundle.main.url(forResource: effect.rawValue, withExtension: nil)
            if (url == nil) {
                print("Could not find file: \(effect.rawValue)")
                return
            }
            
            var error: NSError? = nil
            do {
                self.sfxPlayerDict[effect] = try AVAudioPlayer(contentsOf: url!)
            } catch let error1 as NSError {
                error = error1
                self.sfxPlayerDict[effect] = nil
            }
            guard let player = self.sfxPlayerDict[effect] as? AVAudioPlayer else {
                print("Could not create audio player: \(error!)")
                return
            }
            
            player.numberOfLoops = 0
            if mustLoop{
                player.numberOfLoops = -1
            }
            player.volume = self.sfxVolume
            player.prepareToPlay()
            player.play()
            
            return
        }
        
        if !audioPlayer.isPlaying{
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        }
    }
    
    public func stopSoundEffect(_ effect: SFX){
        let fadeDuration: TimeInterval = 0.1
        if let audioPlayer = self.sfxPlayerDict[effect] as? AVAudioPlayer{
            audioPlayer.setVolume(0, fadeDuration: fadeDuration)
            let _ = Timer.scheduledTimer(timeInterval: fadeDuration, target: self, selector: #selector(stopAudioPlayer(sender:)), userInfo: ["effect": effect], repeats: false)
        }
    }
    
    
    @objc private func stopAudioPlayer(sender: Timer){
        let userInfo = sender.userInfo as! Dictionary<String, AnyObject>
        let effect = userInfo["effect"] as! SFX
        if let audioPlayer = self.sfxPlayerDict[effect] as? AVAudioPlayer{
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            audioPlayer.volume = self.sfxVolume
        }
        
    }
    
    public func changeVolumeSFX(volume: Float){
        self.sfxVolume = volume
        for sfx in SFX.allCases {
            if let player = self.sfxPlayerDict[sfx] as? AVAudioPlayer {
                player.volume = self.sfxVolume
            }
        }
    }
}
