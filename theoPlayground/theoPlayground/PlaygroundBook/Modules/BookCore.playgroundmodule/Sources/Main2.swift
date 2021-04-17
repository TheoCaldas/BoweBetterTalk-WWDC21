//
//  Main1.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import PlaygroundSupport
import SpriteKit
import CoreMotion

public class Main2: SKScene, ShakeDelegate, MicDelegate {
    
    private enum GameUI{
        case shake
        case mic
    }
    
    private enum PlayingState{
        case voiceOver1 //first instruction
        case shakeDetecting //game1
        case voiceOver2 //second instruction
        case blowDetecting //game2
        case finished //ok
    }
    
    private var shake: ShakeDetection?
    private var currentShakeAmount: Float = .zero
    private let shakeAmountTarget: Float = 5.0
    private var wallHits = 0
    
    private var mic: MicDetection?
    private var currentScreamAmount: Float = .zero
    private let screamAmountTarget: Float = 10.0
    
    private var playingState: PlayingState = .voiceOver1
    private var timerVoiceOver1 = TimeCounter()
    private var timerVoiceOver2 = TimeCounter()
    private var timerHint = TimeCounter()
    
    private var boweNode = SKSpriteNode()
    private var darwinNode = SKSpriteNode()
    private var wallNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var shakeNode = SKSpriteNode()
    
    private var boweIsHappy = false
    private var hint1HasAppeared = false
    private var hint2HasAppeared = false
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.darwinNode = self.childNode(withName: "//darwin") as! SKSpriteNode
        self.wallNode = self.childNode(withName: "//wall") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.shakeNode = self.childNode(withName: "//shake") as! SKSpriteNode
        
//        self.progressBarFillNode.xScale = .zero
        
        self.hideUI()
        self.boweIdleTalk()
        Animator.animateDarwin(node: self.darwinNode, animation: .idle, mustLoop: true){}
        SoundManager.sharedInstance().playBackgroundMusic(.minigame2, mustLoop: false)
        self.shake = ShakeDetection(delegate: self)
        self.mic = MicDetection(delegate: self, volumeThreshold: 25.0)
        self.timerVoiceOver1.start()
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        self.updateProgressBar()
        if self.playingState == .voiceOver1{
            if self.timerVoiceOver1.getTime() >= 2.0 && self.timerVoiceOver1.getTime() < 3.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame3VoiceOver1, mustLoop: false)
            }else if self.timerVoiceOver1.getTime() >= 7.0{
                self.startGame1()
            }
        }
        if self.playingState == .voiceOver2{
            if self.timerVoiceOver2.getTime() >= 2.0 && self.timerVoiceOver2.getTime() < 3.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame3VoiceOver2, mustLoop: false)
            }else if self.timerVoiceOver2.getTime() >= 7.0{
                self.startGame2()
            }
        }
        if self.playingState == .shakeDetecting || self.playingState == .voiceOver2{
            self.updateWall()
        }
        if self.playingState == .shakeDetecting || self.playingState == .blowDetecting{
            if self.timerHint.getTime() >= 5.0{
                self.showHint()
            }
        }
    }
    
    func receiveShakeSignal() {
        self.currentShakeAmount += 0.1
        self.timerHint.reset()
        
        if self.currentShakeAmount >= self.shakeAmountTarget{
//            self.currentShakeAmount = .zero
            self.endGame1()
        }
    }
    
    func receiveMicSignal() {
        self.currentScreamAmount += 0.1
        self.timerHint.reset()
        
        if self.currentScreamAmount >= self.screamAmountTarget{
//            self.currentScreamAmount = .zero
            self.endGame2()
        }
    }
    
    private func startGame1(){
        self.timerVoiceOver1.stop()
        self.playingState = .shakeDetecting
        self.shake?.start()
        self.showUI(.shake)
        self.timerHint.start()
    }
    
    private func endGame1(){
        self.timerVoiceOver2.start()
        self.playingState = .voiceOver2
        self.shake?.stop()
        self.hideUI()
        self.timerHint.stop()
        self.timerHint.reset()
        Animator.animateDarwin(node: self.darwinNode, animation: .angry, mustLoop: false){}
    }
    
    private func startGame2(){
        self.timerVoiceOver2.stop()
        self.playingState = .blowDetecting
        self.mic?.settupRecorder()
        self.mic?.startRecorder()
        self.showUI(.mic)
        self.timerHint.start()
    }
    
    private func endGame2(){
        self.playingState = .finished
        self.mic?.stopRecorder()
        self.hideUI()
        self.timerHint.stop()
        self.timerHint.reset()
        PlaygroundPage.current.assessmentStatus = .pass(message: "Finally! Checkout the [last page](@next)")
        Animator.animateDarwin(node: self.darwinNode, animation: .idleHappy, mustLoop: true){}
        SoundManager.sharedInstance().playSoundEffect(.nextLevel, mustLoop: false)
        self.boweIsHappy = true
    }
    
    private func hideUI(){
        self.progressBarFillNode.isHidden = true
        self.progressBarNode.isHidden = true
        self.micNode.isHidden = true
        self.shakeNode.isHidden = true
    }
    
    private func showUI(_ ui: GameUI){
        if ui == .shake{
            self.shakeNode.isHidden = false
        }else{
            self.micNode.isHidden = false
        }
        self.progressBarFillNode.isHidden = false
        self.progressBarNode.isHidden = false
        self.progressBarFillNode.xScale = .zero
    }
    
    private func showHint(){
        if self.playingState == .shakeDetecting{
            if !self.hint1HasAppeared{
                self.hint1HasAppeared = true
                SoundManager.sharedInstance().playSoundEffect(.hint, mustLoop: false)
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["Shake the device to break Bowe's wall!"], solution: nil)
            }
        }else if self.playingState == .blowDetecting{
            if !self.hint2HasAppeared{
                self.hint2HasAppeared = true
                SoundManager.sharedInstance().playSoundEffect(.hint, mustLoop: false)
                PlaygroundPage.current.assessmentStatus = .fail(hints: ["Blow the communication noises away!"], solution: nil)
            }
        }
    }
    
    private func updateProgressBar(){
        if self.playingState == .shakeDetecting{
            let progress = currentShakeAmount/shakeAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }else if self.playingState == .blowDetecting{
            let progress = currentScreamAmount/screamAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }
       
    }
    
    private func updateWall(){
        let progress = currentShakeAmount/shakeAmountTarget
        if self.wallHits == 0 && progress >= 1/3{
            self.wallHits = 1
            Animator.animateWall(node: self.wallNode, animation: .hit1, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallHit, mustLoop: false)
        }else if self.wallHits == 1 && progress >= 2/3{
            self.wallHits = 2
            Animator.animateWall(node: self.wallNode, animation: .hit2, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallHit, mustLoop: false)
        }else if self.wallHits == 2 && progress >= 1{
            self.wallHits = 3
            Animator.animateWall(node: self.wallNode, animation: .falling, mustLoop: false){}
            SoundManager.sharedInstance().playSoundEffect(.wallFalling, mustLoop: false)
        }
    }
    
    private func boweIdleTalk(){
        if self.boweIsHappy{
            Animator.animateBowe(node: self.boweNode, animation: .idleHappy, mustLoop: false){
                SoundManager.sharedInstance().playSoundEffect(.messageClear, mustLoop: false)
                Animator.animateBowe(node: self.boweNode, animation: .talking, mustLoop: false){
                    self.boweIdleTalk()
                }
            }
        }else{
            Animator.animateBowe(node: self.boweNode, animation: .idle, mustLoop: false){
                SoundManager.sharedInstance().playSoundEffect(.messageClear, mustLoop: false)
                Animator.animateBowe(node: self.boweNode, animation: .talking, mustLoop: false){
                    self.boweIdleTalk()
                }
            }
        }
        
    }
}
