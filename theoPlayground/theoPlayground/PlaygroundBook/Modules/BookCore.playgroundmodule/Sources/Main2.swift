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
    
    private var label = SKLabelNode()
    
    private var shake = ShakeDetection()
    private var currentShakeAmount: Float = .zero
    private let shakeAmountTarget: Float = 15.0
    
    override public func didMove(to view: SKView) {
        self.addChild(label)
        label.zPosition = 200
        label.position = CGPoint(x: -400, y: -400)
        label.fontSize = 150
        label.text = "\(self.currentShakeAmount)"
        
        self.shake.delegate = self
        self.shake.start()
    }
    
    override public func update(_ elapsedTime: TimeInterval) {
        
    }
    
    func receiveSignal() {
        self.currentShakeAmount += 0.1
        label.text = "\(self.currentShakeAmount)"
    }
    
}
