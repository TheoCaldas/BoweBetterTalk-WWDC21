//
//  DoodleEffect.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 18/04/21.
//

import Foundation
import SpriteKit

class DoodleEffect{
    
    public enum FieldPosition{
        case none
        case center
        case top
        case bot
        case left
        case right
    }
    
    private var particles = [Particle]()
    private var bounds: ParticleBounds?
    private var field: SKFieldNode?
    
    init(in node: SKNode, point: CGPoint, width: CGFloat, height: CGFloat, numParticles: Int, particlesSpeed: CGFloat?, particlesRadius: CGFloat?, particlesLineWidth: CGFloat?, particlesMaxPoint: Int?, fieldPos: FieldPosition, fieldStrength: Float?){
        
        guard numParticles >= 1 else {return}
        
        self.setField(node: node, fieldPos: fieldPos, point: point, width: width, height: height, fieldStrength: fieldStrength)
        
        self.bounds = ParticleBounds(color: .black, thickness: 10, point: point, height: height, width: width)
        node.addChild(self.bounds!)
        self.bounds!.isHidden = true
                
        for _ in 1...numParticles{
            let particle = Particle(in: node, position: point, speed: particlesSpeed, radius: particlesRadius, lineWidth: particlesLineWidth, maxPoints: particlesMaxPoint)
            self.particles.append(particle)
            node.addChild(particle)
        }
        
    }
    
    public func setField(node: SKNode, fieldPos: FieldPosition, point: CGPoint, width: CGFloat, height: CGFloat, fieldStrength: Float?){
        let fieldNode = SKFieldNode.radialGravityField();
        fieldNode.falloff = 0.0;
        fieldNode.strength = fieldStrength ?? 3;
        fieldNode.position = point
        switch fieldPos {
        case .top:
            fieldNode.position.y += height/2
        case .bot:
            fieldNode.position.y -= height/2
        case .left:
            fieldNode.position.x -= width/2
        case .right:
            fieldNode.position.x += width/2
        default:
            print()
        }
        if fieldPos != .none{
            node.addChild(fieldNode)
            self.field = fieldNode
        }
        
    }
    
    public func startParticlesMove(){
        for particle in self.particles{
            particle.startMove()
        }
    }
    
    public func stopParticlesMove(){
        for particle in self.particles{
            particle.stopMove()
        }
    }
    
    public func updateEffect(){
        for particle in self.particles{
            particle.updateLine()
            particle.renderLine()
        }
    }
    
    public func showField(){
        self.bounds?.isHidden = false
    }
    
}
