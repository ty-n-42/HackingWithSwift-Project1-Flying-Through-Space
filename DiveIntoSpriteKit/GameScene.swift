//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit
import CoreMotion // for accessing device accelerometer and gyroscope

@objcMembers
class GameScene: SKScene, SKPhysicsContactDelegate { // SKPhysicsContactDelegate allows collision notifications to be received by this class
    let player = SKSpriteNode(imageNamed: "player-rocket.png") // player sprite as a property
    let motionManager = CMMotionManager() // gives access to core motion
    var gameTimer: Timer? // timer for regularly creating asteroids
    let scoreLabel = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold") // label to show the score
    var score: Int = 0 { // value of the score
        didSet {
            scoreLabel.text = "SCORE: \(score)" // update the score label when the score changes
        }
    }
    
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        
        // add a background image: starfield
        let background = SKSpriteNode(imageNamed: "space.jpg") // load the image as a sprite
        background.zPosition = -1 // set position behind others
        addChild(background) // add the sprite to the scene
        
        // add scrolling particles: moving space dust
        if let particles = SKEmitterNode(fileNamed: "SpaceDust") { // load the particle effect
            particles.position.x = 512 // position the emitter
            particles.advanceSimulationTime(10) // advance the emitter simulation 10 seconds so the particles fill the view
            addChild(particles) // add the emitter to the scene
        }
        
        // add label to the scene
        scoreLabel.zPosition = 2 // set position in front of others
        scoreLabel.position.y = 300 // position the score label
        addChild(scoreLabel) // add the label to the scene
        score = 0 // set the initial score to 0 - triggers the update of the score label
        
        // add the player sprite - created as class property
        player.position.x = -400 // set x position
        player.zPosition = 1 // set z position so infront of background and starfield
        addChild(player) // add the sprite to the scene
        
        // add a physics body to the player
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size) // make a physics body with the sprite
        player.physicsBody?.categoryBitMask = 1 // set identifier for contact testing (i.e. collision detection)
        
        motionManager.startAccelerometerUpdates() // start collecting accelerometer data
        
        // schedue enemy creation using the game timer
        gameTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.35), repeats: true) { _ in
            self.createEnemy() // create enemy with random rotation
        }
        
        // declare that this object receives collision detection notifications
        physicsWorld.contactDelegate = self
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }

    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
        
        if let accelerometerData = motionManager.accelerometerData { // read the accelerometer
            let changeX = CGFloat(accelerometerData.acceleration.y) * 100 // calculate the change left-right
            let changeY = CGFloat(accelerometerData.acceleration.x) * 100 // calculate the change up-down
            player.position.x -= changeX // move the player horizontally
            player.position.y += changeY // move the player vertically
            
            if abs(changeX) + abs(changeY) <= 2 { // if there is a small movement increase the score
                score += 1
            }
        }
    }
    
    func createEnemy() {
        let sprite = SKSpriteNode(imageNamed: "asteroid.png") // load the image as a sprite
        sprite.position.x = CGFloat(1200) // set the x position - just off the right of the screen
        sprite.position.y = CGFloat(Int.random(in: -350...350)) // set the y position randomly between the top and bottom
        sprite.zPosition = 1 // set the z position the same as the player
        sprite.name = "enemy" // set the sprite name
        addChild(sprite) // add the sprite to the scene
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size) // make a physics body with the sprite
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0) // set the velocity of the physics body
        sprite.physicsBody?.linearDamping = 0 // set the velocity dampening to 0 - none for space
        sprite.physicsBody?.angularVelocity = CGFloat(Int.random(in: -5...5)) // set the spin
        
        sprite.physicsBody?.categoryBitMask = 0 // set identifier for contact testing (ie. collision detection)
        sprite.physicsBody?.contactTestBitMask = 1 // define what other physics bodies to check for collision - compares with the other objects categoryBitMask
    }
    
    // this method is called when the physics system detects a collision
    func didBegin(_ contact: SKPhysicsContact) {
        // get a reference to both objects that collided - quiting the method if either isn't available
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerHit(nodeB)
        } else {
            playerHit(nodeA)
        }
    }
    
    // the player hit the node
    func playerHit(_ node: SKNode) {
        player.removeFromParent() // remove the player
    }
}

