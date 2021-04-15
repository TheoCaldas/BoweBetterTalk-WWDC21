//
//  Animator.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import Foundation
import SpriteKit

private struct FrameDuration{
    var frame: Int
    var duration: TimeInterval
}

class Animator{
    
    public enum BoweAnimation{
        case idle
        case idleSad
        case idleHappy
        case startingShout
        case shouting
        case endingShout
        case talking
    }
    
    public enum DarwinAnimation{
        case idle
        case idleHappy
        case angry
    }
    
    public enum WallAnimation{
        case hit1
        case hit2
        case hit3
        case falling
        case down
    }
    
    static func animateBowe(node: SKSpriteNode, animation: BoweAnimation){
        switch animation {
        case .idle:
            var orderedFrames = [FrameDuration]()
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 5, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 7, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 5, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.5))
            orderedFrames.append(FrameDuration(frame: 8, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 8, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            
            var textures = [SKTexture]()
            var actions = [SKAction]()

            for i in 0...7{
                textures.append(SKTexture(imageNamed: String(format: "boweRespirando%02d", i)))
            }
            
            //otimizar?
            
//            var orderedTextures = [SKTexture]()
//            for i in 0...orderedFrames.count-1{
//                if i == 0{
//                    orderedTextures.append()
//                }
//            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(seq)
        default:
            print()
        }
    }
    
    static func animateDarwin(node: SKSpriteNode, animation: DarwinAnimation){
        switch animation {
        case .idle:
            print()
        default:
            print()
        }
    }
    
    static func animateWall(node: SKSpriteNode, animation: WallAnimation){
        switch animation {
        case .down:
            print()
        default:
            print()
        }
    }
    
}
