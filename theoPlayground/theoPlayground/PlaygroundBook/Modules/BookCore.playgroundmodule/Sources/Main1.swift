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
    private let screamAmountThreshold: Float = 5.0
    
    private let label = SKLabelNode()
    
    override public func didMove(to view: SKView) {
        self.backgroundColor = .red
        self.addChild(self.label)
        self.label.zPosition = 1000
        self.label.text = "\(self.currentScreamAmount)"
        
        self.mic = MicDetection(delegate: self, volumeThreshold: nil)
        self.startGame()
    }
    
    func receiveSignal() {
        self.currentScreamAmount += 0.1

        self.label.text = "\(self.currentScreamAmount)"

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
