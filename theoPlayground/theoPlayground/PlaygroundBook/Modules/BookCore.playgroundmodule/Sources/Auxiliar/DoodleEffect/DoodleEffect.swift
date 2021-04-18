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
    
    private var currentPos: CGPoint = .zero
    
    init(in node: SKNode, point: CGPoint, width: CGFloat, height: CGFloat, numParticles: Int, particlesSpeed: CGFloat?, particlesRadius: CGFloat?, particlesLineWidth: CGFloat?, particlesMaxPoint: Int?, fieldPos: FieldPosition, fieldStrength: Float?){
        
        self.setField(node: node, fieldPos: fieldPos, point: point, width: width, height: height, fieldStrength: fieldStrength)
        
        if width > .zero && height > .zero{
            self.bounds = ParticleBounds(color: .black, thickness: 10, point: point, height: height, width: width)
            node.addChild(self.bounds!)
            self.bounds!.isHidden = true
        }
                
        if numParticles > 0{
            for _ in 1...numParticles{
                let particle = Particle(in: node, position: point, speed: particlesSpeed, radius: particlesRadius, lineWidth: particlesLineWidth, maxPoints: particlesMaxPoint)
                self.particles.append(particle)
                node.addChild(particle)
            }
        }
        
        self.currentPos = point
    }
    
    public func setField(node: SKNode, fieldPos: FieldPosition, point: CGPoint, width: CGFloat, height: CGFloat, fieldStrength: Float?){
        let fieldNode = SKFieldNode.radialGravityField();
        fieldNode.falloff = 0.0;
        fieldNode.strength = fieldStrength ?? 3;
        fieldNode.position = point
        fieldNode.region = SKRegion(size: CGSize(width: width, height: height))
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
    
    public func addParticle(in node: SKNode, speed: CGFloat?, radius: CGFloat?, lineWidth: CGFloat?, maxPoints: Int?){
        let particle = Particle(in: node, position: self.currentPos, speed: speed, radius: radius, lineWidth: lineWidth, maxPoints: maxPoints)
        self.particles.append(particle)
        node.addChild(particle)
        particle.startMove()
    }
    
    public func removeParticle(duration: TimeInterval){
        if particles.count >= 1{
            let particle = particles.last!
            particle.stopMove()
            particle.stopRender(duration: duration)
            particle.removeFromParent()
            particles.removeLast()
        }
    }
    
    public func removeAllParticles(duration: TimeInterval){
        for particle in particles{
            particle.stopMove()
            particle.stopRender(duration: duration)
            particle.removeFromParent()
        }
        particles = [Particle]()
    }
    
    public func moveTo(point: CGPoint, duration: TimeInterval){
        let action = SKAction.move(to: point, duration: duration)
        action.timingMode = .easeIn
        self.bounds?.run(action)
        self.field?.run(action)
        self.currentPos = point
    }
    
    public func moveParticleTo(point: CGPoint, duration: TimeInterval){
        if particles.count >= 1{
            let particle = particles.last!
            particle.physicsBody?.collisionBitMask = Category.none
            particle.physicsBody?.contactTestBitMask = Category.none
            particle.run(SKAction.move(to: point, duration: duration), completion: {
                particle.physicsBody?.collisionBitMask = Category.all
                particle.physicsBody?.contactTestBitMask = Category.all
            })
        }
    }
    
    public func moveParticleTo(doodle: DoodleEffect, duration: TimeInterval, timeInterval: TimeInterval){
        if particles.count >= 1{
            let particle = particles.last!
            particle.physicsBody?.collisionBitMask = Category.none
            particle.physicsBody?.contactTestBitMask = Category.none
            particle.startMove(timeInterval: timeInterval)
            particle.run(SKAction.move(to: doodle.currentPos, duration: duration), completion: {
                particle.physicsBody?.collisionBitMask = Category.all
                particle.physicsBody?.contactTestBitMask = Category.all
//                doodle.particles.append(particle)
//                self.particles.removeLast()
                particle.startMove()
            })

        }
    }
    
    public func getParticlesCount() -> Int{
        return self.particles.count
    }
}
