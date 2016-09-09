//
//  GameScene.swift
//  FlappyClone
//
//  Created by Bennett Hartrick on 9/9/16.
//  Copyright (c) 2016 Bennett. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let Ghost: UInt32 = 0x1 << 1
    static let Ground: UInt32 = 0x1 << 2
    static let Wall: UInt32 = 0x1 << 3
}

class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        ground.physicsBody?.affectedByGravity = false
        ground.physicsBody?.dynamic = false
        
        // Ground appears infront of everything
        ground.zPosition = 3
        
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width / 2 - ghost.frame.width, y: self.frame.height / 2)
        
        ghost.physicsBody = SKPhysicsBody(circleOfRadius: ghost.frame.height / 2)
        ghost.physicsBody?.categoryBitMask = PhysicsCategory.Ghost
        ghost.physicsBody?.collisionBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall
        ghost.physicsBody?.affectedByGravity = true
        ghost.physicsBody?.dynamic = true
        
        // Ghost appears in front of the wall but behind the ground
        ghost.zPosition = 2
        
        self.addChild(ghost)
        
        createWalls()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        ghost.physicsBody?.velocity = CGVectorMake(0, 0)
        ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        
    }
    
    func createWalls() {
        
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        bottomWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        bottomWall.physicsBody = SKPhysicsBody(rectangleOfSize: bottomWall.size)
        bottomWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        bottomWall.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        bottomWall.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        bottomWall.physicsBody?.dynamic = false
        bottomWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(M_PI)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        // Sets walls to be behind the ground
        wallPair.zPosition = 1
        
        self.addChild(wallPair)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
