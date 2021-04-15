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
    
    private var mic: MicDetection?
    private var currentScreamAmount: Float = .zero
    private let screamAmountThreshold: Float = 100.0
    
    private var hasDetected = false
    private var timeSinceLastDetection: TimeInterval = .zero
    
    private var boweNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        
        Animator.animateBowe(node: self.boweNode, animation: .idle){}
        
        self.mic = MicDetection(delegate: self, volumeThreshold: nil)
        self.startGame()
    }
    
    override public func update(_ currentTime: TimeInterval) {
        self.timeSinceLastDetection += 0.1
        if self.hasDetected && self.timeSinceLastDetection >= 0.5 {
            Animator.animateBowe(node: self.boweNode, animation: .pauseShout){}
        }
    }
    
    
    func receiveSignal() {
        self.currentScreamAmount += 0.1
        
        if !self.hasDetected{
            self.hasDetected = true
            Animator.animateBowe(node: self.boweNode, animation: .startingShout){
                Animator.animateBowe(node: self.boweNode, animation: .shouting){}
            }
        }
        else{
            if self.timeSinceLastDetection >= 0.5{
                Animator.animateBowe(node: self.boweNode, animation: .shouting){}
            }
        }
        
        self.timeSinceLastDetection = .zero
        
        if self.currentScreamAmount >= self.screamAmountThreshold{
            self.currentScreamAmount = .zero
            self.endGame()
        }
    }
    
    private func startGame(){
        self.mic?.settupRecorder()
        self.mic?.startRecorder()
        PlaygroundPage.current.assessmentStatus = .fail(hints: ["Scream close to the device screen to help Bowe!"], solution: nil)
    }
    
    private func endGame(){
        self.mic?.stopRecorder()
        PlaygroundPage.current.assessmentStatus = .pass(message: "Much Better! Please, go to the [next page](@next)")
    }
}
