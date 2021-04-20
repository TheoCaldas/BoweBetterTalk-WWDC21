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
    private let screamAmountTarget: Float = 10.0
    
    private var playingState: PlayingState = .notStarted
    private var timeSinceLastDetection = TimeCounter()
    private var timeBeforeFirstDetection = TimeCounter()
    private var timeAfterEnding = TimeCounter()
    
    private var boweNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    
    private var hintHasAppeared = false
    private var screamWasInterrupted = false
    
    private var boweDoodle: DoodleEffect?
    private var bigDoodle: DoodleEffect?
    private var mouthDoodle: DoodleEffect?
    
    private var doodleCount = 0
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.progressBarFillNode.xScale = .zero
        self.hideUI()
        
        self.boweDoodle = DoodleEffect(in: self.boweNode, point: CGPoint(x: 10, y: -340), width: 250, height: 130, numParticles: 3, particlesSpeed: 5, particlesRadius: 10, particlesLineWidth: 15, particlesMaxPoint: 50, fieldPos: .center, fieldStrength: 7)
        self.boweDoodle?.startParticlesMove()
        
        self.bigDoodle = DoodleEffect(in: self.boweNode, point: CGPoint(x: -400, y: 400), width: 400, height: 400, numParticles: 0, particlesSpeed: 10, particlesRadius: 15, particlesLineWidth: 20, particlesMaxPoint: 100, fieldPos: .center, fieldStrength: 7)
        self.bigDoodle?.startParticlesMove()
        
        self.mouthDoodle = DoodleEffect(in: self.boweNode, point: CGPoint(x: -10, y: -160), width: 100, height: 100, numParticles: 0, particlesSpeed: 10, particlesRadius: 15, particlesLineWidth: 20, particlesMaxPoint: 20, fieldPos: .center, fieldStrength: 0)
        self.mouthDoodle?.startParticlesMove()
                
        timeBeforeFirstDetection.start()
        Animator.animateBowe(node: self.boweNode, animation: .idleSad, mustLoop: true){}
        SoundManager.sharedInstance().playBackgroundMusic(.minigame2, mustLoop: false)
        self.mic = MicDetection(delegate: self, volumeThreshold: 15.0)
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        self.renderDoodles()
        if self.playingState == .notStarted{
            if self.timeBeforeFirstDetection.getTime() >= 3.0 && self.timeBeforeFirstDetection.getTime() < 4.0{
                SoundManager.sharedInstance().playSoundEffect(.minigame2VoiceOver, mustLoop: false)
            }
            if self.timeBeforeFirstDetection.getTime() >= 10.0{
                self.startGame()
            }
        }
        if self.playingState == .started{
            if self.timeBeforeFirstDetection.getTime() >= 13.0{
                self.showHint()
            }
        }
        if self.playingState == .playing{
            self.updateProgressBar()
            self.updateDoodles()
            
            if self.timeSinceLastDetection.getTime() >= 0.1 {
                self.interruptScream()
            }
            if self.timeSinceLastDetection.getTime() >= 3.0{
                self.showHint()
            }
        }
        if self.playingState == .finished{
            self.updateDoodles()
            if timeAfterEnding.getTime() >= 3.0{
                self.removeDoodles()
            }
        }
    }
    
    
    func receiveMicSignal() {
        self.currentScreamAmount += 0.1
        
        if (self.mouthDoodle?.getParticlesCount())! <= 0{
            self.mouthDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 20, maxPoints: 300)
            self.mouthDoodle?.moveParticleTo(doodle: self.bigDoodle!, duration: 0.5, timeInterval: 0.5)
        }
        
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
            self.endGame()
        }
    }
    
    private func startGame(){
        self.playingState = .started
        self.mic?.settupRecorder()
        self.mic?.startRecorder()
        self.showUI()
        SoundManager.sharedInstance().changeVolumeBackgroundMusic(volume: 0.5)
        SoundManager.sharedInstance().changeVolumeSFX(volume: 0.5)
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
        SoundManager.sharedInstance().changeVolumeBackgroundMusic(volume: 1.0)
        SoundManager.sharedInstance().changeVolumeSFX(volume: 1.0)
        self.mouthDoodle?.removeAllParticles(duration: 0.3)
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
            self.mouthDoodle?.removeAllParticles(duration: 0.3)
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
    
    private func renderDoodles(){
        self.boweDoodle!.renderEffect()
        self.bigDoodle!.renderEffect()
        self.mouthDoodle!.renderEffect()
    }
    
    private func removeDoodles(){
        self.boweDoodle?.removeAllParticles(duration: 2.0)
        self.bigDoodle?.removeAllParticles(duration: 2.0)
        self.mouthDoodle?.removeAllParticles(duration: 2.0)
    }
    
    private func updateDoodles(){
        let progress = currentScreamAmount/screamAmountTarget
        if progress >= 1/5 && self.doodleCount == 0{
            self.doodleCount = 1
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
        }else if progress >= 1/3 && self.doodleCount == 1{
            self.doodleCount = 2
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.boweDoodle?.removeParticle(duration: 1.0)
        }else if progress >= 2/3 && self.doodleCount == 2{
            self.doodleCount = 3
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.boweDoodle?.removeParticle(duration: 1.0)
        }else if progress >= 1 && self.doodleCount == 3{
            self.doodleCount = 4
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.bigDoodle?.addParticle(in: self.boweNode, speed: 10, radius: 15, lineWidth: 30, maxPoints: 100)
            self.boweDoodle?.removeParticle(duration: 1.0)
            self.timeAfterEnding.start()
        }
        
    }
}
