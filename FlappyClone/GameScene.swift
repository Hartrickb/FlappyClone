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
    static let Score: UInt32 = 0x1 << 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    var wallPair = SKNode()
    
    var moveAndRemove = SKAction()
    
    var gameStarted = Bool()
    
    var score = Int()
    let scoreLabel = SKLabelNode()
    var restartButton = SKSpriteNode()
    
    var died = Bool()
    
    func restartScene() {
        
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
        
    }
    
    func createScene() {
        
        self.physicsWorld.contactDelegate = self
        
        scoreLabel.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLabel.text = "\(score)"
        scoreLabel.zPosition = 4
        self.addChild(scoreLabel)
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: ground.size)
        // Sets which category the ground physics body belongs to
        ground.physicsBody?.categoryBitMask = PhysicsCategory.Ground
        
        // Tells ground that the ghost physics category can collide with it
        ground.physicsBody?.collisionBitMask = PhysicsCategory.Ghost
        
        // Sends a notification if the ghost physics body hits the ground
        ground.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        ground.physicsBody?.affectedByGravity = false
        // Does not move when hit
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
        ghost.physicsBody?.contactTestBitMask = PhysicsCategory.Ground | PhysicsCategory.Wall | PhysicsCategory.Score
        ghost.physicsBody?.affectedByGravity = false
        ghost.physicsBody?.dynamic = true
        
        // Ghost appears in front of the wall but behind the ground
        ghost.zPosition = 2
        
        self.addChild(ghost)
        
    }
    
    override func didMoveToView(view: SKView) {
        
        /* Setup your scene here */
        
        createScene()
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Ghost || firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Score {
            score += 1
            scoreLabel.text = "\(score)"
        }
        
        if firstBody.categoryBitMask == PhysicsCategory.Ghost && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Ghost {
            
            died = true
            createButton()
            
        }
        
    }
    
    func createButton() {
        restartButton = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: 200, height: 100))
        restartButton.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartButton.zPosition = 5
        self.addChild(restartButton)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            
            gameStarted = true
            ghost.physicsBody?.affectedByGravity = true
            
            // Creates walls with a two second delay between them
            let spawn = SKAction.runBlock {
                self.createWalls()
            }
            
            let delay = SKAction.waitForDuration(2.0)
            let spawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatActionForever(spawnDelay)
            self.runAction(spawnDelayForever)
            
            // Moves walls from right to left
            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance, y: 0, duration: NSTimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])
            
            ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            
        } else {
            
            if died == true {
                
            } else {
                ghost.physicsBody?.velocity = CGVectorMake(0, 0)
                ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }
        }
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if died == true {
                if restartButton.containsPoint(location) {
                    restartScene()
                }
                
            }
        }
        
    }
    
    // Sets up Walls
    func createWalls() {
        
        let scoreNode = SKSpriteNode()
        scoreNode.size = CGSize(width: 1, height: 200)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCategory.Ghost
        scoreNode.color = UIColor.blueColor()
        
        wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 350)
        
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
        
        let randomPosition = CGFloat.randomNumber(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y + randomPosition
        wallPair.addChild(scoreNode)
        
        wallPair.runAction(moveAndRemove)
        
        self.addChild(wallPair)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
