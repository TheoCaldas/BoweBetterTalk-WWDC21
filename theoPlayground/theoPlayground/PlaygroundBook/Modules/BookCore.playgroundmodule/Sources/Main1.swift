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
    
    enum PlayingState{
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
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.progressBarFillNode.xScale = .zero
        self.hideUI()
                
        timeBeforeFirstDetection.start()
        
        Animator.animateBowe(node: self.boweNode, animation: .idleSad){}
        
        self.mic = MicDetection(delegate: self, volumeThreshold: nil)
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        if self.playingState == .notStarted{
            if self.timeBeforeFirstDetection.getTime() >= 5.0{
                self.startGame()
            }
        }
        if self.playingState == .started{
            if self.timeBeforeFirstDetection.getTime() >= 10.0{
                self.showHint()
            }
        }
        if self.playingState == .playing{
            let progress = currentScreamAmount/screamAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
            
            if self.timeSinceLastDetection.getTime() >= 0.1 {
                Animator.animateBowe(node: self.boweNode, animation: .pauseShout){}
            }
            if self.timeSinceLastDetection.getTime() >= 5.0{
                self.showHint()
            }
        }
    }
    
    
    func receiveSignal() {
        self.currentScreamAmount += 0.1
        
        if self.playingState == .started{
            self.playingState = .playing
            self.timeSinceLastDetection.start()
            self.timeBeforeFirstDetection.stop()
            Animator.animateBowe(node: self.boweNode, animation: .startingShout){
                Animator.animateBowe(node: self.boweNode, animation: .shouting){}
            }
        }
        else if self.playingState == .playing{
            if self.timeSinceLastDetection.getTime() >= 0.1{
                Animator.animateBowe(node: self.boweNode, animation: .shouting){}
            }
        }
        
        self.timeSinceLastDetection.reset()
        
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
        Animator.animateBowe(node: self.boweNode, animation: .endingShout){
            PlaygroundPage.current.assessmentStatus = .pass(message: "Much Better! Please, go to the [next page](@next)")
            Animator.animateBowe(node: self.boweNode, animation: .idleHappy){}
        }
        self.hideUI()
    }
    
    private func showHint(){
        if !self.hintHasAppeared{
            self.hintHasAppeared = true
            PlaygroundPage.current.assessmentStatus = .fail(hints: ["Scream as loud as you can in front of the device!"], solution: nil)
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
}
