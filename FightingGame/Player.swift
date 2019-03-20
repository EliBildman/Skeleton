//
//  Player.swift
//  FightingGame
//
//  Created by Eli Bildman on 1/3/19.
//  Copyright © 2019 Eli Bildman. All rights reserved.
//

import Foundation
import SpriteKit

class Player : Sprite {
    
    var deTex : SKTexture
    var scale : CGFloat
    let playerSpeed : CGFloat = 200
    let jumpPower : CGFloat = 500
    var attack : HitBox?
    var blocking = false
    
    let airJumps = 1
    var currJumps : Int
    
    init(pos : CGPoint, scale: CGFloat, stage: SKSpriteNode) {
        currJumps = airJumps
        deTex  = SKTextureAtlas(named: "idle-0_1").textureNamed("frame_00.png")
        self.scale = scale
        
        super.init(texture: deTex , color: UIColor.clear, size: deTex.size(), stage: stage, maxHealth: 10)
        buildAnis(["walk-0_05", "idle-0_1", "attack-0_1", "hit-0_1", "die-0_1"])
        attack = HitBox(circleOf: 30, offset: CGVector(dx: 0, dy: size.height / 2))
        position = pos
        anchorPoint = CGPoint(x: 0.5, y: 0)
        setScale(scale)
        setPhysics()
        
    }
    
    func setPhysics() {
        let trim = CGPoint(x: 0.6, y: 0.8)
        let offset = CGVector(dx: -12, dy: 0)
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: deTex.size().width * scale * trim.x, height: deTex.size().height * scale * trim.y), center: CGPoint(x: offset.dx, y: deTex.size().height / 2 * scale * trim.y + offset.dy))
        physicsBody?.collisionBitMask = 1
        physicsBody?.categoryBitMask = 0
        physicsBody?.restitution = 0
        physicsBody?.allowsRotation = false
        physicsBody?.affectedByGravity = true
        
    }
    
    override func update(inputs : Set<UITouch>) {
        if(alive) {
            handleInputs(inputs)
            if(!hasActions()) {
                idle()
            }
            if(touchingGround()) {
                currJumps = airJumps
                if(action(forKey: "walk") == nil) {
                    physicsBody?.velocity.dx = 0
                }
            }
        }
        super.update(inputs: inputs)
    }
    
    func handleInputs(_ inputs : Set<UITouch>) {
        var move = 0
        for i in inputs {
            if(i.location(in: parent!).x > parent!.frame.width / 2) {
                move += 1
            } else {
                move  -= 1
            }
        }
        
        if(move > 0) {
            walk(dir.right)
        } else if (move < 0) {
            walk(dir.left)
        } else {
            removeAction(forKey: "walk")
        }
        
    }
    
    override func die() {
        removeAllActions()
        run(anis["die"]!)
        super.die()
    }
    
    override func hit(dmg: CGFloat) {
        if(alive && !blocking) {
            removeAllActions()
            removeAllChildren()
            run(anis["hit"]!)
        }
        super.hit(dmg: dmg)
    }
    
    
    func idle() {
        run(SKAction.repeatForever(anis["idle"]!), withKey: "idle")
    }
    
    
    func attack(_ direction: dir) {
        if(alive) {
            if(action(forKey: "attack") == nil) {
            
                addChild(attack!)
                
                face(direction)
                removeAllActions()
                run(SKAction.sequence([anis["attack"]!, SKAction.run {
                    self.removeAllChildren()
                    }]), withKey: "attack")
            }
        }
    }
    
    
    
    func walk(_ direction: dir) {
        if((!hasActions()) || action(forKey: "idle") != nil) {
            removeAction(forKey: "idle")
            face(direction)
            run(SKAction.repeatForever(anis["walk"]!), withKey: "walk")
            
        }
        physicsBody?.velocity.dx = (direction == dir.right ? playerSpeed : -playerSpeed)
    }
    
    @objc func jump() {
        if(alive) {
            if(currJumps > 0 && action(forKey: "attack") == nil) {
                physicsBody!.velocity.dy = jumpPower
                if(!touchingGround()) {
                    currJumps -= 1
                }
            }
        }
    }
    
    func block() {
        print("block")
        
    }
    
    func fastFall() {
        physicsBody?.velocity.dy = -1000
    }
    
    
    @objc func test() {
        print("hello")
    }
    
    @objc func rightSwipe() {
        attack(dir.right)
    }
    
    @objc func leftSwipe() {
        attack(dir.left)
    }
    
    @objc func upSwipe() {
        jump()
    }
    
    @objc func downSwipe() {
        if(touchingGround()) {
            block()
        } else {
            fastFall()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

