//
//  Sprite.swift
//  FightingGame
//
//  Created by Eli Bildman on 1/8/19.
//  Copyright © 2019 Eli Bildman. All rights reserved.
//

import Foundation
import SpriteKit

class Sprite : SKSpriteNode {
    
    var anis : [String:SKAction] = [:]
    var direction : dir = dir.right
    var stage : SKSpriteNode
    var health : CGFloat
    var alive : Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(texture: SKTexture?, color: UIColor, size: CGSize, stage: SKSpriteNode, maxHealth : CGFloat) {
        self.stage = stage
        self.health = maxHealth
        super.init(texture: texture, color: color, size: size)
    }
    
    func face(_ d : dir) {
        if(d != direction) {
            xScale *= -1
            direction = d
        }
    }
    
    func update(inputs : Set<UITouch>) {
        if(alive && health <= 0) {
            die()
        }
    }
    
    func die() {
        alive = false
        print(type(of: self), " is dead")
    }
    
    func hit(dmg: CGFloat) {
        if(alive) {
            health -= dmg
        }
    }
    
    func buildAnis(_ names: [String]) {
        for j in 0...names.count - 1 {
            let atlas = SKTextureAtlas(named: names[j])
            var textures = [SKTexture]()
            let delay = Double( names[j].split(separator: "-")[1].split(separator: "_").joined(separator: ".") )!
            for i in 0...atlas.textureNames.count - 1 {
                textures.append(atlas.textureNamed("frame_" + (i < 10 ? "0" : "") + String(i)))
                textures[i].filteringMode = .nearest
            }
            anis[String(names[j].split(separator: "-")[0])] = SKAction.animate(with: textures, timePerFrame: delay, resize: true, restore: false)
        }
    }

    
    func touchingGround() -> Bool {
        if(physicsBody != nil && stage.physicsBody != nil) {
            return physicsBody!.allContactedBodies().contains(stage.physicsBody!)
        } else {
            return false
        }
    }
    
    func magOf(_ vec: CGVector) -> CGFloat {
        return sqrt(vec.dx * vec.dx + vec.dy * vec.dy)
    }
    
    func comp(_ vec: CGVector, onto: CGVector) -> CGFloat {
        return dot(vec, onto) / magOf(onto)
    }
    
    func dot(_ vec1: CGVector, _ vec2: CGVector) -> CGFloat {
        return vec1.dx * vec2.dx + vec1.dy * vec2.dy
    }
    
    func mulVec(_ vec : CGVector, by: CGFloat) -> CGVector {
        return CGVector(dx: vec.dx * by, dy: vec.dy * by)
    }
    
}

public enum dir {
    case left
    case right
}

