//
//  GameScene.swift
//  20FireworksNight
//
//  Created by Satwika on 4/22/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var background: SKSpriteNode!
    var fireworks = [SKNode]()
    var gameTimer: Timer?
    var numOfLaunches = 0
    
    var leftEdge: Double = -22
    var rightEdge: Double = 1024+22
    var bottomEdge: Double = -22
    
    var scoreLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel?.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 15, y: 15)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: [], repeats: true)
    }
    
    func createFireworks(xMovement: Double, x: Double, y: Double){
        
        let mainNode = SKNode()
        mainNode.position = CGPoint(x: x, y: y)
        
        
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        mainNode.addChild(firework)
        
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            break
        }
        
        if let fuse = SKEmitterNode(fileNamed: "fuse") {
            fuse.position = CGPoint(x: 0, y: -23)
            mainNode.addChild(fuse)
        }
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))
        
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 50)
        mainNode.run(move)
       
        fireworks.append(mainNode)
        addChild(mainNode)
        
    }
    
    @objc func launchFireworks(){
        numOfLaunches += 1
        guard numOfLaunches <= 10 else {
            gameTimer?.invalidate()
            
            let gameOver = SKLabelNode(fontNamed: "Chalkduster")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.horizontalAlignmentMode = .center
            gameOver.text = "GAME OVER!!!"
            gameOver.fontSize = 48
            addChild(gameOver)
            
            scoreLabel.position = CGPoint(x: 512, y: 330)
            scoreLabel.horizontalAlignmentMode = .center
            removeNodes(removeAll: true)
            return
        }
        let xmo: Double = 1800
        switch Int.random(in: 0...3){
        case 0:
            // straight up
            createFireworks(xMovement: 0, x: 512-200, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512-100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512+100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512+200, y: bottomEdge)
        case 1:
            // fan
            createFireworks(xMovement: -200, x: 512-200, y: bottomEdge)
            createFireworks(xMovement: -100, x: 512-100, y: bottomEdge)
            createFireworks(xMovement: 0, x: 512, y: bottomEdge)
            createFireworks(xMovement: 100, x: 512+100, y: bottomEdge)
            createFireworks(xMovement: 200, x: 512+200, y: bottomEdge)
        case 2:
            // from left to right
            createFireworks(xMovement: xmo, x: leftEdge, y: bottomEdge)
            createFireworks(xMovement: xmo, x: leftEdge, y: bottomEdge+100)
            createFireworks(xMovement: xmo, x: leftEdge, y: bottomEdge+200)
            createFireworks(xMovement: xmo, x: leftEdge, y: bottomEdge+300)
            createFireworks(xMovement: xmo, x: leftEdge, y: bottomEdge+400)
        case 3:
            // from right to left
            createFireworks(xMovement: -xmo, x: rightEdge, y: bottomEdge)
            createFireworks(xMovement: -xmo, x: rightEdge, y: bottomEdge+100)
            createFireworks(xMovement: -xmo, x: rightEdge, y: bottomEdge+200)
            createFireworks(xMovement: -xmo, x: rightEdge, y: bottomEdge+300)
            createFireworks(xMovement: -xmo, x: rightEdge, y: bottomEdge+400)
        default:
            break
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches: touches)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches: touches)
    }
    
    func checkTouches(touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        
        let nodesAtPoint = nodes(at: touch.location(in: self))
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "firework"{
                for parent in fireworks{
                    guard let firewrk = parent.children.first as? SKSpriteNode else {continue}
                    if firewrk.name == "selected" && firewrk.color != node.color {
                        firewrk.name = "firework"
                        firewrk.colorBlendFactor = 1
                    }
                }
                node.name = "selected"
                node.colorBlendFactor = 0
            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        removeNodes(removeAll: false)
    }
    
    func removeNodes(removeAll: Bool){
        for (index, firework) in fireworks.enumerated().reversed() {
            
            if firework.position.y > 900 || removeAll {
                firework.removeFromParent()
                fireworks.remove(at: index)
            }
        }
    }
    
    func explode(firework: SKNode){
        guard let explodeEmitter = SKEmitterNode(fileNamed: "explode") else { return }
        explodeEmitter.position = firework.position
        addChild(explodeEmitter)
    
        firework.removeFromParent()
        
        // removing after the explode
        let delay = SKAction.wait(forDuration: TimeInterval(explodeEmitter.particleLifetime))
        let removeEmitter = SKAction.removeFromParent()
        explodeEmitter.run(SKAction.sequence([delay, removeEmitter]))
    }
    
    func explodeFireworks() {
        var numOfExploded = 0
        
        for (index, fireworkCont) in fireworks.enumerated().reversed() {
            guard let firework = fireworkCont.children.first as? SKSpriteNode else { continue }
            
            if firework.name == "selected"{
                fireworks.remove(at: index)
                explode(firework: fireworkCont)
                numOfExploded += 1
            }
        }
        
        switch numOfExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    
    
    
    
}
