//
//  Animator.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 15/04/21.
//

import Foundation
import SpriteKit

class Animator{
    
    private struct FrameDuration{
        var frame: Int
        var duration: TimeInterval
    }
    
    public enum BoweAnimation{
        case idle
        case idleSad
        case idleHappy
        case startingShout
        case shouting
        case pauseShout
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
    
    static func animateBowe(node: SKSpriteNode, animation: BoweAnimation, completion: @escaping() -> Void){
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
            node.run(SKAction.repeatForever(seq))
            
        case .startingShout:
            var textures = [SKTexture]()
            
            for i in 0...3{
                textures.append(SKTexture(imageNamed: String(format: "boweGritando%02d", i)))
            }
        
            let animate = SKAction.animate(with: textures, timePerFrame: 0.1)
            
            node.removeAllActions()
            node.run(animate, completion: completion)
        case .shouting:
            var textures = [SKTexture]()
            
            for i in 4...5{
                textures.append(SKTexture(imageNamed: String(format: "boweGritando%02d", i)))
            }
        
            let animate = SKAction.animate(with: textures, timePerFrame: 0.1)
            
            node.removeAllActions()
            node.run(SKAction.repeatForever(animate))
        case .pauseShout:
            let texture = SKTexture(imageNamed: String(format: "boweGritando%02d", 6))

            node.texture = texture
            node.removeAllActions()
        case .endingShout:
            var textures = [SKTexture]()
            
            for i in 7...10{
                textures.append(SKTexture(imageNamed: String(format: "boweGritando%02d", i)))
            }
        
            let animate = SKAction.animate(with: textures, timePerFrame: 0.1)
            
            node.removeAllActions()
            node.run(animate, completion: completion)
        case .idleHappy:
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
                textures.append(SKTexture(imageNamed: String(format: "boweRespirandoFeliz%02d", i)))
            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(SKAction.repeatForever(seq))
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
