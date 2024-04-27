//
//  GameScene.swift
//  17SpaceRace
//
//  Created by Satwika on 4/21/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var backgroundEmitter: SKEmitterNode!
    var playerNode: SKSpriteNode!
    var possibleEnemies = ["ball", "hammer", "tv"]
    var gameOver = false
    var gameTimer: Timer!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        
        backgroundEmitter = SKEmitterNode(fileNamed: "starfield")
        backgroundEmitter.position = CGPoint(x: 1024, y: 384)
        backgroundEmitter.zPosition = -1
        backgroundEmitter.advanceSimulationTime(10)
        addChild(backgroundEmitter)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 15, y: 15)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 30
        addChild(scoreLabel)
        
        playerNode = SKSpriteNode(imageNamed: "player")
        playerNode.position = CGPoint(x: 70, y: 384)
        playerNode.physicsBody = SKPhysicsBody(texture: playerNode.texture!, size: playerNode.size)
        playerNode.physicsBody?.contactTestBitMask = 1
        addChild(playerNode)
        
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(addEnemies), userInfo: nil, repeats:true)
        
        
    }
    
    @objc func addEnemies(){
        
        guard !gameOver else {
            gameTimer.invalidate()
            return
        }
    
        guard let enemy = possibleEnemies.randomElement() else { return }
        
        let enemyNode = SKSpriteNode(imageNamed: enemy)
        enemyNode.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        enemyNode.physicsBody = SKPhysicsBody(texture: enemyNode.texture!, size: enemyNode.size)
        enemyNode.physicsBody?.categoryBitMask = 1
        enemyNode.physicsBody?.velocity = CGVector(dx: -300, dy: 0)
        enemyNode.physicsBody?.angularVelocity = 5
        enemyNode.physicsBody?.linearDamping = 0
        enemyNode.physicsBody?.angularDamping = 0
        addChild(enemyNode)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        
        if !gameOver {
            score += 1
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        gameOverFunc()
    }
    
    func gameOverFunc(){
        let contactEmitter = SKEmitterNode(fileNamed: "explosion")!
        contactEmitter.position = playerNode.position
        addChild(contactEmitter)
        
        playerNode.removeFromParent()
        
        gameOver = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var loc = touch.location(in: self)
        if loc.y < 100{
            loc.y = 100
        } else if loc.y > 650{
            loc.y = 650
        }
        playerNode.position = loc
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let loc = touches.first?.location(in: self) else { return }
        gameOverFunc()
    }
}
