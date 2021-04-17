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
        case noHit
        case hit1
        case hit2
        case falling
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
        case .idleSad:
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
                textures.append(SKTexture(imageNamed: String(format: "boweRespirandoTriste%02d", i)))
            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(SKAction.repeatForever(seq))
        case .talking:
            var orderedFrames = [FrameDuration]()
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            
            var textures = [SKTexture]()
            var actions = [SKAction]()

            for i in 0...3{
                textures.append(SKTexture(imageNamed: String(format: "boweFalando%02d", i)))
            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(seq, completion: completion)
        }
    }
    
    static func animateDarwin(node: SKSpriteNode, animation: DarwinAnimation, completion: @escaping() -> Void){
        switch animation {
        case .idle:
            var orderedFrames = [FrameDuration]()
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 5, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.5))
            
            var textures = [SKTexture]()
            var actions = [SKAction]()

            for i in 0...5{
                textures.append(SKTexture(imageNamed: String(format: "darwinRespirando%02d", i)))
            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(SKAction.repeatForever(seq))
        case .idleHappy:
            var orderedFrames = [FrameDuration]()
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 3, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 2, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 5, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 4, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.2))
            orderedFrames.append(FrameDuration(frame: 6, duration: 0.1))
            orderedFrames.append(FrameDuration(frame: 1, duration: 0.5))
            
            var textures = [SKTexture]()
            var actions = [SKAction]()

            for i in 0...5{
                textures.append(SKTexture(imageNamed: String(format: "darwinRespirandoFeliz%02d", i)))
            }
        
            for frameDuration in orderedFrames{
                actions.append(SKAction.animate(with: [textures[frameDuration.frame-1]], timePerFrame: frameDuration.duration))
            }
            
            let seq = SKAction.sequence(actions)
            node.removeAllActions()
            node.run(SKAction.repeatForever(seq))
        case .angry:
            let texture = SKTexture(imageNamed: String(format: "darwinChateado%02d", 0))
            node.texture = texture
            node.removeAllActions()
        }
    }
    
    static func animateWall(node: SKSpriteNode, animation: WallAnimation, completion: @escaping() -> Void){
        switch animation {
        case .noHit:
            let texture = SKTexture(imageNamed: String(format: "paredeCaindo%02d", 0))
            node.texture = texture
            node.removeAllActions()
        case .hit1:
            let texture = SKTexture(imageNamed: String(format: "paredeCaindo%02d", 1))
            node.texture = texture
            node.removeAllActions()
        case .hit2:
            let texture = SKTexture(imageNamed: String(format: "paredeCaindo%02d", 2))
            node.texture = texture
            node.removeAllActions()
        case .falling:
            var textures = [SKTexture]()
            
            for i in 3...9{
                textures.append(SKTexture(imageNamed: String(format: "paredeCaindo%02d", i)))
            }
        
            let animate = SKAction.animate(with: textures, timePerFrame: 0.2)
            
            node.removeAllActions()
            node.run(animate, completion: completion)
        }
    }
    
}
