//
//  ParticleBounds.swift
//  BookCore
//
//  Created by Theo Necyk Agner Caldas on 18/04/21.
//

import Foundation
import SpriteKit

struct Category {
 static let none: UInt32              = 0
 static let particle: UInt32         = 0b1
 static let field: UInt32               = 0b10
 static let all: UInt32               = 0b11
    
 static func allBut(_ categories:UInt32...)->UInt32 {
    return categories.reduce(Self.all, { a, b in a-b})
 }
}

class ParticleBounds: SKShapeNode {
    
    var fieldWidthStart: CGFloat
    var fieldWidthEnd: CGFloat
    var fieldHeightStart: CGFloat
    var fieldHeightEnd: CGFloat
    
    init(color: UIColor, thickness: CGFloat, point: CGPoint, height: CGFloat, width: CGFloat){
        
        self.fieldWidthStart = -width/2 + thickness
        self.fieldWidthEnd = width/2 - thickness
        self.fieldHeightStart = -height/2 + thickness
        self.fieldHeightEnd = height/2 - thickness
        
        super.init()
        self.isUserInteractionEnabled = false

        let myPath = CGMutablePath()
        let height = height
        let width = width
        let bottomBoard = [
            CGPoint(x: -width/2 + point.x, y: -height/2 + point.y),
            CGPoint(x: -width/2 + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: width/2 + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: width/2 + point.x , y: -height/2 + point.y)
        ]
        
        let topBoard = [
            CGPoint(x: -width/2 + point.x, y:height/2 + point.y),
            CGPoint(x: -width/2 + point.x, y:height/2 - thickness + point.y),
            CGPoint(x: width/2 + point.x, y:height/2 - thickness + point.y),
            CGPoint(x: width/2 + point.x, y:height/2 + point.y)
        ]
        
        let rightBoard = [
            CGPoint(x: width/2 + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: width/2 - thickness + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: width/2 - thickness + point.x, y: height/2 - thickness + point.y),
            CGPoint(x: width/2 + point.x, y:height/2 - thickness + point.y)
        ]
        
        let leftBoard = [
            CGPoint(x: -width/2 + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: -width/2 + thickness + point.x, y: -height/2 + thickness + point.y),
            CGPoint(x: -width/2 + thickness + point.x, y:height/2 - thickness + point.y),
            CGPoint(x: -width/2 + point.x, y:height/2 - thickness + point.y)
        ]
        
        myPath.addLines(between: bottomBoard)
        myPath.closeSubpath()
        myPath.addLines(between: topBoard)
        myPath.closeSubpath()
        myPath.addLines(between: rightBoard)
        myPath.closeSubpath()
        myPath.addLines(between: leftBoard)
        myPath.closeSubpath()
        self.path = myPath
        self.fillColor = color
        self.strokeColor = color
        self.physicsBody = SKPhysicsBody(bodies: [physicsBodyFrom(bottomBoard), physicsBodyFrom(topBoard), physicsBodyFrom(rightBoard), physicsBodyFrom(leftBoard)])
        
        self.physicsBody?.categoryBitMask = Category.field
        self.physicsBody?.collisionBitMask = Category.all
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.density = CGFloat.greatestFiniteMagnitude
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.isDynamic = false
        self.isHidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func physicsBodyFrom(_ coordenates:[CGPoint])->SKPhysicsBody {
        let physicsBodyPath = CGMutablePath()
        physicsBodyPath.addLines(between: coordenates)
        let physicsBody = SKPhysicsBody(polygonFrom: physicsBodyPath)
        self.physicsBody?.categoryBitMask = Category.field
        self.physicsBody?.collisionBitMask = Category.all
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.pinned = true
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.density = CGFloat.greatestFiniteMagnitude
        self.physicsBody?.usesPreciseCollisionDetection = true
        return physicsBody
    }
}

