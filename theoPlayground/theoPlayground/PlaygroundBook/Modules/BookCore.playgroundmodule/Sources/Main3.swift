//
//  Main3.swift
//  BookCore
//
//  Created by Eduarda Mello on 12/04/21.
//

import Foundation
import PlaygroundSupport
import SpriteKit

public class Main3 : SKScene {
    public override func didMove(to view: SKView) {
        SoundManager.sharedInstance().playBackgroundMusic(.page3, mustLoop: false)
    }
}
