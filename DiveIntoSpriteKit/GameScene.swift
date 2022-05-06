//
//  GameScene.swift
//  DiveIntoSpriteKit
//
//  Created by Paul Hudson on 16/10/2017.
//  Copyright © 2017 Paul Hudson. All rights reserved.
//

import SpriteKit

@objcMembers
class GameScene: SKScene {
    let player = SKSpriteNode(imageNamed: "player-rocket.png") // player sprite as a property
    
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
        
        // add the player sprite - created as class property
        player.position.x = -400 // set x position
        player.zPosition = 1 // set z position so infront of background and starfield
        addChild(player) // add the sprite to the scene
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }

    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
    }
}

