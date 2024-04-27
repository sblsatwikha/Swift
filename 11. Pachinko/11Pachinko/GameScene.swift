//
//  GameScene.swift
//  11Pachinko
//
//  Created by Satwika on 4/11/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let balls = ["ballBlue", "ballYellow", "ballPurple", "ballGrey", "ballRed", "ballCyan", "ballGreen"]
    
    var LimitLabel: SKLabelNode!
    
    var ballsLimit = 5 {
        didSet{
            LimitLabel.text = "Balls Left: \(ballsLimit)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingLabel: SKLabelNode!
    
    var editingMode = false {
        didSet{
            if editingMode {
                editingLabel.text = "Done"
            } else {
                editingLabel.text = "Edit"
            }
        }
    }
    
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 900, y: 700)
        addChild(scoreLabel)
        
        editingLabel = SKLabelNode(fontNamed: "Chalkduster")
        editingLabel.text = "Edit"
        editingLabel.position = CGPoint(x: 200, y: 700)
        addChild(editingLabel)
        
        LimitLabel = SKLabelNode(fontNamed: "Chalkduster")
        LimitLabel.text = "Balls Left: \(ballsLimit)"
        LimitLabel.position = CGPoint(x: 500, y: 700)
        addChild(LimitLabel)
        
        for i in 0...4 {
            makeBouncer(at: CGPoint(x: i*256, y: 0))
        }
        
        for i in 0...3 {
            var isGood = true
            if(i%2 != 0){
                isGood = false
            }
            makeSlot(at: CGPoint(x: 128+(i*256), y: 0), isGood: isGood)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            
            let nodes = nodes(at: loc)
            
            if nodes.contains(editingLabel){
                editingMode.toggle()
            }
            else{
                if editingMode {
                    let color = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: CGFloat.random(in: 0...1))
                    let size = CGSize(width: CGFloat.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: color, size: size)
                    box.name = "Obstacle"
                    box.position = loc
                    box.zRotation = CGFloat.random(in: 0...3)
                    
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    
                    addChild(box)
                }
                else {
                    if ballsLimit > 0 {
                        let ball = SKSpriteNode(imageNamed: balls[Int.random(in: 0...6)])
                        ball.position = CGPoint(x: loc.x, y: 768)
                        ball.name = "Ball"
                        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
                        ball.physicsBody?.restitution = 0.5
                        ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                        addChild(ball)
                        ballsLimit -= 1
                    } else {
                        print("No balls")
                    }
                    
                }
            }
            
        }
    }
    
    func makeBouncer(at position: CGPoint){
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width/2)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    func makeSlot(at position: CGPoint, isGood: Bool){
        let slotBase: SKSpriteNode
        let slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "Good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "Bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)
        
    }
    
    func collisionBetween(ball: SKNode, object: SKNode){
        if object.name == "Good"{
            destroy(ball: ball)
            score += 1
            ballsLimit += 1
        } else if object.name == "Bad"{
            destroy(ball: ball)
            score -= 1
        } else if object.name == "Obstacle" {
            object.removeFromParent()
        }
    }
    
    func destroy(ball: SKNode){
        
        if let emittor = SKEmitterNode(fileNamed: "FireParticles") {
            emittor.position = ball.position
            addChild(emittor)
        }
        
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "Ball"{
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "Ball"{
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }

}
