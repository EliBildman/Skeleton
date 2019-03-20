//
//  HitBox.swift
//  FightingGame
//
//  Created by Eli Bildman on 1/8/19.
//  Copyright © 2019 Eli Bildman. All rights reserved.
//

import Foundation
import SpriteKit

class HitBox : SKNode {
    
    init(rectOf: CGSize, offset: CGVector) {
        super.init()
        physicsBody = SKPhysicsBody(rectangleOf: rectOf, center: CGPoint(x: offset.dx, y: offset.dy))
        initPhysics()
    }
    
    init(circleOf: CGFloat, offset: CGVector) {
        super.init()
        physicsBody = SKPhysicsBody(circleOfRadius: circleOf, center: CGPoint(x: offset.dx, y: offset.dy))
        initPhysics()
    }
    
    func initPhysics() {
        physicsBody?.isDynamic = false
        physicsBody?.collisionBitMask = 2
        physicsBody?.categoryBitMask = 0
    }
    
    func touching() -> [SKNode] {
        var nodes : [SKNode] = []
        for b in physicsBody!.allContactedBodies() {
            nodes.append(b.node!)
        }
        return nodes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
