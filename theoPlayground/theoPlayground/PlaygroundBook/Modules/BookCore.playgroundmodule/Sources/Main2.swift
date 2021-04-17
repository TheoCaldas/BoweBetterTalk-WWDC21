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
    private let shakeAmountTarget: Float = 15.0
    
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
        
        self.addChild(label)
        label.zPosition = 200
        label.position = CGPoint(x: -400, y: -400)
        label.fontSize = 150
        label.text = "\(self.currentShakeAmount)"
        
        self.hideUI()
        Animator.animateBowe(node: self.boweNode, animation: .idle){}
        Animator.animateDarwin(node: self.darwinNode, animation: .idle){}
        
        self.shake.delegate = self
        self.shake.start()
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        
    }
    
    func receiveSignal() {
        self.currentShakeAmount += 0.1
        label.text = "\(self.currentShakeAmount)"
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
    
}
