//
//  Particle.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 18/04/21.
//

import Foundation

import SpriteKit

public extension CGVector {
    func magnitude() -> CGFloat {
        return sqrt(self.dx*self.dx + self.dy*self.dy)
    }
}


class Particle: SKSpriteNode {
    
    private var pathArray = [CGPoint]()
    private var line = SKShapeNode()
    private var maxPoints = 100
    
    private var particleSpeed: CGFloat = 10
    private var maxVelocity: CGFloat = 300
    
    private var timer = Timer()
        
    init(in parent: SKNode, position: CGPoint, speed: CGFloat?, radius: CGFloat?, lineWidth: CGFloat?, maxPoints: Int?) {
        super.init(texture: nil, color: .black, size: CGSize(width: 30, height: 30))
        self.isUserInteractionEnabled = false
        self.physicsBody = SKPhysicsBody(circleOfRadius: radius ?? 15)
        self.physicsBody?.categoryBitMask = Category.particle
        self.physicsBody?.collisionBitMask = Category.all
        self.physicsBody?.contactTestBitMask = Category.all
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = true
        self.physicsBody?.restitution = 1
        self.physicsBody?.allowsRotation = true
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        self.physicsBody?.angularDamping = 0
        self.isHidden = true
        self.position = position
        
        if let particleSpeed = speed{
            self.particleSpeed = particleSpeed
            self.maxVelocity = 30*particleSpeed
        }
        
        if let particleMaxPoints = maxPoints{
            self.maxPoints = particleMaxPoints
        }
        
        self.line.fillColor = .clear
        self.line.lineWidth = lineWidth ?? 20
        self.line.strokeColor = .black
        self.line.lineCap = .round
        self.line.glowWidth = 0
        parent.addChild(self.line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateLine(){
        if self.pathArray.count > self.maxPoints{
            self.pathArray.remove(at: 0)
        }
        self.pathArray.append(self.position)
    }
    
    public func renderLine(){
        let path = CGMutablePath()
        path.move(to: self.pathArray[0])
        
        for point in self.pathArray{
            path.addLine(to: point)
        }
        
        self.line.path = path
    }
    
    private func accelerate() {
        if self.physicsBody!.velocity.magnitude() > maxVelocity{
            self.physicsBody!.velocity = .zero
        }
        let randomAngle = CGFloat.random(in: 0...CGFloat.pi*2)
        let randomSpeed = CGFloat.random(in: self.particleSpeed/2...self.particleSpeed)
        let vector = CGVector(dx: randomSpeed * cos(randomAngle), dy: randomSpeed * sin(randomAngle))
        self.physicsBody?.applyImpulse(vector)
    }
    
    private func forceAccelerate() {
        if self.physicsBody!.velocity.magnitude() > maxVelocity{
            self.physicsBody!.velocity = .zero
        }
        let randomAngle = CGFloat.random(in: 0...CGFloat.pi*2)
        let randomSpeed = self.particleSpeed//*3
        let vector = CGVector(dx: randomSpeed * cos(randomAngle), dy: randomSpeed * sin(randomAngle))
        self.physicsBody?.applyImpulse(vector)
    }
    
    public func startMove(){
        self.stopMove()
        self.accelerate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(accelerateTimer), userInfo: nil, repeats: true)
    }
    
    public func startMove(timeInterval: TimeInterval){
        self.stopMove()
        self.forceAccelerate()
        self.timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(forceAccelerateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func accelerateTimer(){
        self.accelerate()
    }
    
    @objc private func forceAccelerateTimer(){
        self.forceAccelerate()
    }
    
    public func stopMove(){
        self.timer.invalidate()
        self.physicsBody!.velocity = .zero
        self.physicsBody!.angularVelocity = .zero
    }
    
    public func stopRender(duration: TimeInterval){
        self.line.run(SKAction.fadeOut(withDuration: 1.0), completion: {self.line.removeFromParent()})
    }
}
