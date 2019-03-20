//
//  GameScene.swift
//  FightingGame
//
//  Created by Eli Bildman on 1/3/19.
//  Copyright © 2019 Eli Bildman. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var player : Player?
    private var idleAni: [SKTexture] = []
    var inputs : Set<UITouch> = []
    var sprites : [Sprite] = []
    
    override func didMove(to view: SKView) {
        
        print("0.1")
        
        let ground = SKSpriteNode(color: UIColor.white, size: CGSize(width: view.frame.width, height: 10))
        ground.position = CGPoint(x: frame.midX, y: 20)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.collisionBitMask = 1
        ground.physicsBody?.categoryBitMask = 1
        ground.physicsBody?.restitution = 0
        
        
        
        player = Player(pos: CGPoint(x: frame.midX, y: 200), scale: 3, stage: ground)
        let bird = Bird(pos: CGPoint(x: 300, y: 200), scale: 0.1, speed: 200, stage: ground, target: player!)
        
        configureGestures()
        
        sprites.append(player!)
        sprites.append(bird)
        
        addChild(ground)
        addChild(player!)
        addChild(bird)
        
        physicsWorld.gravity.dy *= 0.75
        
    }
    
    func configureGestures() {
        
        let swipeRight = UISwipeGestureRecognizer()
        let swipeLeft = UISwipeGestureRecognizer()
        let swipeUp = UISwipeGestureRecognizer()
        let swipeDown = UISwipeGestureRecognizer()
        
        swipeRight.direction = .right
        swipeRight.addTarget(player as Any, action: #selector(player?.rightSwipe))
        view?.addGestureRecognizer(swipeRight)
        
        swipeLeft.direction = .left
        swipeLeft.addTarget(player as Any, action: #selector(player?.leftSwipe))
        view?.addGestureRecognizer(swipeLeft)
        
        swipeUp.direction = .up
        swipeUp.addTarget(player as Any, action: #selector(player?.upSwipe))
        view?.addGestureRecognizer(swipeUp)
        
        swipeDown.direction = .down
        swipeDown.addTarget(player as Any, action: #selector(player?.downSwipe))
        view?.addGestureRecognizer(swipeDown)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            inputs.insert(t)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            inputs.remove(t)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            inputs.remove(t)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        for s in sprites {
            s.update(inputs: inputs)
        }
        
    }
}
