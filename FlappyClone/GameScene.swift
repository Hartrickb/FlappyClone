//
//  GameScene.swift
//  FlappyClone
//
//  Created by Bennett Hartrick on 9/9/16.
//  Copyright (c) 2016 Bennett. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var ground = SKSpriteNode()
    var ghost = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        ground = SKSpriteNode(imageNamed: "Ground")
        ground.setScale(0.5)
        ground.position = CGPoint(x: self.frame.width / 2, y: 0 + ground.frame.height / 2)
        
        self.addChild(ground)
        
        ghost = SKSpriteNode(imageNamed: "Ghost")
        ghost.size = CGSize(width: 60, height: 70)
        ghost.position = CGPoint(x: self.frame.width / 2 - ghost.frame.width, y: self.frame.height / 2)
        
        self.addChild(ghost)
        
        createWalls()
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
       
    }
    
    func createWalls() {
        
        let wallPair = SKNode()
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let bottomWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 350)
        bottomWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 - 350)
        
        topWall.setScale(0.5)
        bottomWall.setScale(0.5)
        
        wallPair.addChild(topWall)
        wallPair.addChild(bottomWall)
        
        self.addChild(wallPair)
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
