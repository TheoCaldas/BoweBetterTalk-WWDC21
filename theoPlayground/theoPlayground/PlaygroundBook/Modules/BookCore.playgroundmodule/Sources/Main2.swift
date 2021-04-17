//
//  Main1.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import PlaygroundSupport
import SpriteKit
import CoreMotion

public class Main2: SKScene, ShakeDelegate {
    
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
    
    private var label = SKLabelNode()
    
    private var shake = ShakeDetection()
    private var currentShakeAmount: Float = .zero
    private let shakeAmountTarget: Float = 10.0
    private var wallHits = 0
    
    private var playingState: PlayingState = .voiceOver1
    
    private var boweNode = SKSpriteNode()
    private var darwinNode = SKSpriteNode()
    private var wallNode = SKSpriteNode()
    private var progressBarNode = SKSpriteNode()
    private var progressBarFillNode = SKSpriteNode()
    private var micNode = SKSpriteNode()
    private var shakeNode = SKSpriteNode()
    
    override public func didMove(to view: SKView) {
        self.boweNode = self.childNode(withName: "//bowe") as! SKSpriteNode
        self.darwinNode = self.childNode(withName: "//darwin") as! SKSpriteNode
        self.wallNode = self.childNode(withName: "//wall") as! SKSpriteNode
        self.progressBarNode = self.childNode(withName: "//progressBar") as! SKSpriteNode
        self.progressBarFillNode = self.childNode(withName: "//progressBarFill") as! SKSpriteNode
        self.micNode = self.childNode(withName: "//mic") as! SKSpriteNode
        self.shakeNode = self.childNode(withName: "//shake") as! SKSpriteNode
        
        self.progressBarFillNode.xScale = .zero
        
        self.addChild(label)
        label.zPosition = 200
        label.position = CGPoint(x: -400, y: -400)
        label.fontSize = 150
        label.text = "\(self.currentShakeAmount)"
        
        self.hideUI()
        self.boweIdleTalk()
        Animator.animateDarwin(node: self.darwinNode, animation: .idle, mustLoop: true){}
        
        self.shake.delegate = self
        self.startGame1()
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        self.updateProgressBar()
        if self.playingState == .shakeDetecting || self.playingState == .voiceOver2{
            self.updateWall()
        }
    }
    
    func receiveSignal() {
        self.currentShakeAmount += 0.1
        label.text = "\(self.currentShakeAmount)"
        
        if self.currentShakeAmount >= self.shakeAmountTarget{
//            self.currentShakeAmount = .zero
            self.endGame1()
        }
    }
    
    private func startGame1(){
        self.playingState = .shakeDetecting
        self.shake.start()
        self.showUI(.shake)
    }
    
    private func endGame1(){
        self.playingState = .voiceOver2
        self.shake.stop()
        self.hideUI()
    }
    
    private func startGame2(){
        
    }
    
    private func endGame2(){
        
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
    }
    
    private func updateProgressBar(){
        if self.playingState == .shakeDetecting{
            let progress = currentShakeAmount/shakeAmountTarget
            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }else if self.playingState == .blowDetecting{
//            let progress = currentScreamAmount/screamAmountTarget
//            self.progressBarFillNode.run(SKAction.scaleX(to: CGFloat(progress), duration: 0.02))
        }
       
    }
    
    private func updateWall(){
        let progress = currentShakeAmount/shakeAmountTarget
        if self.wallHits == 0 && progress >= 1/3{
            self.wallHits = 1
            Animator.animateWall(node: self.wallNode, animation: .hit1, mustLoop: false){}
        }else if self.wallHits == 1 && progress >= 2/3{
            self.wallHits = 2
            Animator.animateWall(node: self.wallNode, animation: .hit2, mustLoop: false){}
        }else if self.wallHits == 2 && progress >= 1{
            self.wallHits = 3
            Animator.animateWall(node: self.wallNode, animation: .falling, mustLoop: false){}
        }
    }
    
    private func boweIdleTalk(){
        Animator.animateBowe(node: self.boweNode, animation: .idle, mustLoop: false){
            Animator.animateBowe(node: self.boweNode, animation: .talking, mustLoop: false){
                self.boweIdleTalk()
            }
        }
    }
}
