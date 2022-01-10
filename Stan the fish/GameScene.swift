// GameScene.swift
//
//  GameScene.swift
//  Stan the fish by Jean Nguyen 

import GameplayKit
import SpriteKit

@objcMembers
class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player-submarine")
    
    var gameTimer: Timer?
        
    override func didMove(to view: SKView) {
        // this method is called when your game scene is ready to run
        let background = SKSpriteNode(imageNamed: "water.jpg")
        background.zPosition = -1
        addChild(background)
        // create a bubbles effect
        if let particles = SKEmitterNode(fileNamed: "Bubbles"){
            particles.position.x = 512
            particles.advanceSimulationTime(10)
            addChild(particles)
        }
        //position of the player
        player.position = CGPoint(x: -400, y: 250)
        addChild(player)
        physicsWorld.gravity = CGVector(dx: 0,dy: -5)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
             
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user touches the screen
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 300)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // this method is called when the user stops touching the screen
    }

    override func update(_ currentTime: TimeInterval) {
        // this method is called before each frame is rendered
        let value = player.physicsBody!.velocity.dy * 0.001
        let rotate = SKAction.rotate(toAngle: value, duration: 0.1)
        player.run(rotate)
    }
    
    func createEnemy(){
        let randomDistribution = GKRandomDistribution(lowestValue: -350, highestValue: 350)
        let sprite = SKSpriteNode(imageNamed: "fish")
        
        sprite.position = CGPoint(x:1200, y: randomDistribution.nextInt())
        sprite.name = "enemy"
        sprite.zPosition = 1
        addChild(sprite)
        
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx:-500, dy: 0)
        sprite.physicsBody?.linearDamping = 0
    }
    
}

