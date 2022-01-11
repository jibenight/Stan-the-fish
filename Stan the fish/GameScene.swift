// GameScene.swift
//
//  GameScene.swift
//  Stan the fish by Jean Nguyen 

import GameplayKit
import SpriteKit

@objcMembers
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "player-submarine")
    
    var gameTimer: Timer?
        
    override func didMove(to view: SKView) {
        //position of the player
        player.position = CGPoint(x: -400, y: 250)
        addChild(player)
        player.physicsBody?.categoryBitMask = 1
        physicsWorld.gravity = CGVector(dx: 0,dy: -5)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        
        // launch the parallax effect
        parallaxScroll(image: "sea", y: 0, z: -3, duration: 10, needsPhysics: false)
        parallaxScroll(image: "sand", y: -340, z: -1, duration: 6, needsPhysics: true)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(createObstacle), userInfo: nil, repeats: true)
        
        physicsWorld.contactDelegate = self
             
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
    
    func createObstacle(){
        //create and position the enemy
        let obstacle = SKSpriteNode(imageNamed: "fish")
        obstacle.zPosition = -2
        obstacle.position.x = 768
        addChild(obstacle)
        
        // for collision
        obstacle.physicsBody = SKPhysicsBody(texture: obstacle.texture!, size: obstacle.texture!.size())
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.contactTestBitMask = 1
        obstacle.name = "obstacle"

        //decide where to create it
        let rand = GKRandomDistribution(lowestValue: -300, highestValue: 350)
        obstacle.position.y = CGFloat(rand.nextInt())
        //make it move across the screen
        let action = SKAction.moveTo(x: -768, duration: 9)
        obstacle.run(action)
        }
    
    func playerHit(_ node: SKNode){
        if node.name == "obstacle"{
            if let explosion = SKEmitterNode(fileNamed: "WaterExplosion") {
                explosion.position = player.position
                addChild(explosion)
            }
            player.removeFromParent()
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else {return}
        guard let nodeB = contact.bodyB.node else {return}
        
        if nodeA == player{
            playerHit(nodeB)
        }else if nodeB == player{
            playerHit(nodeA)
        }
    }
    
    
    // create a parralax effect for the background
    func parallaxScroll(image: String, y: CGFloat, z: CGFloat, duration: Double, needsPhysics: Bool){
        //run this code twice
        for i in 0 ... 1 {
            let node = SKSpriteNode(imageNamed: image)
            //position the first node on the left, and position the second on the right
            node.position = CGPoint(x:1023 * CGFloat(i), y: y)
            node.zPosition = z
            addChild(node)
            // for collission
            if needsPhysics {
                node.physicsBody = SKPhysicsBody(texture: node.texture!, size: node.texture!.size())
                node.physicsBody?.isDynamic = false
                node.physicsBody?.contactTestBitMask = 1
                node.name = "obstacle"
            }
            // make this node move the width of the screen by whatever duration was passed in
            let move = SKAction.moveBy(x: -1024, y: 0, duration: duration)
            // make it jump back to the right edge
            let wrap = SKAction.moveBy(x: 1024, y: 0, duration: 0)
            // make these two as a sequence that loops forever
            let sequence = SKAction.sequence([move, wrap])
            let forever = SKAction.repeatForever(sequence)
            // run the animations
            node.run(forever)
       }
    }
}


