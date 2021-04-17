//
//  Main1.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import PlaygroundSupport
import SpriteKit
import Foundation

public class Main1: SKScene, MicDelegate {
    
    private enum PlayingState{
        case notStarted //opens scene
        case started //end of instruction
        case playing //first detection
        case finished //target reached
    }
    
    private var mic: MicDetection?
    private var currentScreamAmount: Float = .zero
    private let screamAmountTarget: Float = 15.0
    
    private var playingState: PlayingState = .notStarted
    private var timeSinceLastDetection = TimeCounter()
    private var timeBeforeFirstDetection = TimeCounter()
    
    private var boweNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    
    private var hintHasAppeared = false
    private var screamWasInterrupted = false
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.progressBarFillNode.xScale = .zero
        self.hideUI()
                
        timeBeforeFirstDetection.start()
        Animator.animateBowe(node: self.boweNode, animation: .idleSad, mustLoop: true){}
        SoundManager.sharedInstance().playBackgroundMusic(.minigame2, mustLoop: false)
        self.mic = MicDetection(delegate: self, volumeThreshold: 15.0)
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        if self.playingState == .notStarted{
            if self.timeBeforeFirstDetection.getTime() >= 3.0 && self.timeBeforeFirstDetection.getTime() < 4.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame2VoiceOver, mustLoop: false)
            }
            if self.timeBeforeFirstDetection.getTime() >= 10.0{
                self.startGame()
            }
        }
        if self.playingState == .started{
            if self.timeBeforeFirstDetection.getTime() >= 15.0{
                self.showHint()
            }
        }
        if self.playingState == .playing{
            self.updateProgressBar()
            
            if self.timeSinceLastDetection.getTime() >= 0.1 {
                self.interruptScream()
            }
            if self.timeSinceLastDetection.getTime() >= 5.0{
                self.showHint()
            }
        }
    }
    
    
    func receiveMicSignal() {
        self.currentScreamAmount += 0.1
        
        if self.playingState == .started{
            self.playingState = .playing
            self.timeSinceLastDetection.start()
            self.timeBeforeFirstDetection.stop()
            SoundManager.sharedInstance().playSoundEffect(.boweScream, mustLoop: false)
            Animator.animateBowe(node: self.boweNode, animation: .startingShout, mustLoop: false){
                Animator.animateBowe(node: self.boweNode, animation: .shouting, mustLoop: true){}
            }
        }
        else if self.playingState == .playing{
            if self.timeSinceLastDetection.getTime() >= 0.2{
                SoundManager.sharedInstance().playSoundEffect(.boweScream, mustLoop: false)
                Animator.animateBowe(node: self.boweNode, animation: .shouting, mustLoop: true){}
            }
        }
        
        self.timeSinceLastDetection.reset()
        self.screamWasInterrupted = false
        
        if self.currentScreamAmount >= self.screamAmountTarget{
            self.currentScreamAmount = .zero
            self.endGame()
        }
    }
    
    private func startGame(){
        self.playingState = .started
        self.mic?.settupRecorder()
        self.mic?.startRecorder()
        self.showUI()
    }
    
    private func endGame(){
        self.playingState = .finished
        self.mic?.stopRecorder()
        Animator.animateBowe(node: self.boweNode, animation: .endingShout, mustLoop: false){
            PlaygroundPage.current.assessmentStatus = .pass(message: "Much Better! Go to the [next page](@next)")
            Animator.animateBowe(node: self.boweNode, animation: .idleHappy, mustLoop: true){}
            SoundManager.sharedInstance().playSoundEffect(.nextLevel, mustLoop: false)
        }
        self.hideUI()
        SoundManager.sharedInstance().stopSoundEffect(.boweScream)
    }
    
    private func showHint(){
        if !self.hintHasAppeared{
            self.hintHasAppeared = true
            SoundManager.sharedInstance().playSoundEffect(.hint, mustLoop: false)
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Scream as loud as you can in front of the device!"], solution: nil)
        }
    }
    
    private func interruptScream(){
        if !self.screamWasInterrupted{
            self.screamWasInterrupted = true
            SoundManager.sharedInstance().stopSoundEffect(.boweScream)
            Animator.animateBowe(node: self.boweNode, animation: .pauseShout, mustLoop: false){}
        }
    }
    
    private func hideUI(){
        self.progressBarFillNode.isHidden = true
        self.progressBarNode.isHidden = true
        self.micNode.isHidden = true
    }
    
    private func showUI(){
        self.progressBarFillNode.isHidden = false
        self.progressBarNode.isHidden = false
        self.micNode.isHidden = false
    }
    
    private func updateProgressBar(){
        let progress = currentScreamAmount/screamAmountTarget
        self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
    }
}
