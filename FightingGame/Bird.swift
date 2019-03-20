//
//  Bird.swift
//  FightingGame
//
//  Created by Eli Bildman on 1/8/19.
//  Copyright © 2019 Eli Bildman. All rights reserved.
//

import Foundation
import SpriteKit

class Bird : Sprite {
    
    var deTex : SKTexture
    var scale : CGFloat
    let target : Sprite
    let accel : CGFloat
    let attackDmg : CGFloat = 1
    
    init(pos: CGPoint, scale: CGFloat, speed: CGFloat, stage: SKSpriteNode, target: Sprite) {
        deTex = SKTextureAtlas(named: "fly-15_0").textureNamed("frame_00.png")
        self.scale = scale
        self.target = target
        self.accel = 1
        super.init(texture: deTex, color: UIColor.clear, size: deTex.size(), stage: stage, maxHealth: 10)
        self.position = pos
        self.speed = speed
        setScale(scale)
        buildAnis(["fly-15_0"])
        setPhysics()
        run(SKAction.repeatForever(anis["fly"]!))
        
    }
    
    func setPhysics() {
        physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        physicsBody?.collisionBitMask = 1
        physicsBody?.categoryBitMask = 3
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = false
        physicsBody?.friction = 100
    }
    
    override func update(inputs: Set<UITouch>) {
        if(alive && target.alive) {
            if(touchingTarget()) {
                attack()
            }
            moveTowardsTarget()
            if(target.position.x < position.x) {
                face(dir.left)
            } else {
                face(dir.right)
            }
        }
        super.update(inputs: inputs)
    }
    
    func attack() {
        target.hit(dmg: attackDmg)
        print(target.health)
        physicsBody?.applyForce(mulVec(dirToTarget(), by: -50))
    }
    
    func moveTowardsTarget() {
        if(comp(physicsBody!.velocity, onto: dirToTarget()) <= speed) {
            physicsBody?.applyForce(mulVec(dirToTarget(), by: accel))
        }
    }
    
    func dirToTarget() -> CGVector {
        return CGVector(dx: target.position.x - position.x, dy: target.position.y - position.y)
    }
    
    func touchingTarget() -> Bool {
        return (physicsBody?.allContactedBodies().contains((target.physicsBody)!))!
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
