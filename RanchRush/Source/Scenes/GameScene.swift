//
//  GameScene.swift
//  RanchRush
//
//  Created by Thaynara da Silva Andrade on 04/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var scoreValue = 0{
        didSet{
            scoreCounter.text = "Points: \(scoreValue)"
        }
    }

    var isScoreCounting: Bool = true

    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    let player: Player = {
        let player = Player()
        player.setFrames()
        player.anchorPoint = CGPoint(x: 0.515, y: 0.15)
        player.zPosition = 2
        player.xScale = 0.5
        player.yScale = 0.5
        return player
    } ()

    var scoreCounter: SKLabelNode = {
        let scoreCounter = SKLabelNode()
        scoreCounter.scene?.anchorPoint = CGPoint(x: 1, y: 1)
        scoreCounter.fontSize = 30
        scoreCounter.fontColor = .black
        scoreCounter.zPosition = 3
        return scoreCounter
    }()
    
    let obstacleTypes: [ObstacleType] = [.female, .male]
    var numberObstacles = 5
    var sceneSpeed: CGFloat = 4

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.jump()
        player.run(SKAction.applyImpulse(CGVector(dx: 0, dy: 110), duration: 0.2))
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.zero
        backgroundColor = UIColor(named: "background")!
        addSwipeGestureRecognizer()
        player.loopForever(state: .idle)
        setScene()
        self.physicsWorld.contactDelegate = self
    }

    override func update(_ currentTime: CFTimeInterval) {
        moveGround()
        moveSky()
        if isScoreCounting == true {
            scoreValue += 1
        }

        let activeObstacles = children.compactMap{ $0 as? Obstacle }
        for child in activeObstacles {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        if activeObstacles.isEmpty {
            createObstacles()
            if numberObstacles < 30 {
                numberObstacles += 2
            }
//            if obstaclesSpeed < 10 {
//                obstaclesSpeed += 1
//            }
        }
    }


    func addSwipeGestureRecognizer() {
        let swipeDirections: [UISwipeGestureRecognizer.Direction] = [.up, .down]
        for direction in swipeDirections {
            let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            swipeRecognizer.direction = direction
            self.view?.addGestureRecognizer(swipeRecognizer)
        }
    }
    
    @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction{
        case .up:
            player.jump()
        case .down:
            player.dead()
        default:
            print("Sem gesture!")
        }
    }
    
    func createObstacles() {
        let obstacleOffsetx: CGFloat = 120
        
       let obstacles = generateRandomObstacles(
            spaceBetween: obstacleOffsetx,
            numberObstacles: self.numberObstacles
        )
        
        for obstacle in obstacles {
            addChild(obstacle)
        }
    }
    
    func createGround() {
        for i in 0...3{
            let ground = SKSpriteNode(imageNamed: "image-background")
            ground.name = "image-background"
            ground.zPosition = 2
            ground.xScale = 1
            ground.yScale = 0.3
            ground.calculateSize(windowWidth: frame.width, windowHeight: frame.height)
            ground.anchorPoint = CGPoint.zero
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width,
                                      y: frame.minY - (ground.frame.height/3))
            ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                            width: ground.size.width,
                            height: ground.size.height * 2.0))
                        ground.physicsBody?.isDynamic = false
            self.addChild(ground)
        }
    }
    
    func createSky(){
        for i in 0...3{
            let sky = SKSpriteNode(imageNamed: "image-sky")
            sky.name = "image-sky"
            sky.xScale = 1
            sky.yScale = 1
            sky.calculateSize(windowWidth: frame.width, windowHeight: frame.height)
            sky.anchorPoint = CGPoint.zero
            sky.zPosition = 1
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width,
                                   y: frame.minY)
            self.addChild(sky)
        }
    }
    
    func moveGround() {
        enumerateChildNodes(withName: "image-background") { node, error in
            node.position.x -= self.sceneSpeed
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
                
            }
        }
    }
    
    func moveSky() {
        enumerateChildNodes(withName: "image-sky") { node, error in
            node.position.x -= self.sceneSpeed/3
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
                
            }
        }
    }
    
    func generateRandomObstacles(spaceBetween: CGFloat, numberObstacles: Int) -> [Obstacle] {
        var obstacleTypeIndex = 0
        let extraDistance = Array(stride(from: 50, to: 150, by: 10))
        var obstacles: [Obstacle] = []
        var currentXPosition = frame.maxX
        let ground = childNode(withName: "image-background")
        
        for _ in 0...(numberObstacles-1) {
            obstacleTypeIndex = Int.random(in: 0..<obstacleTypes.count)
            let obstacle = Obstacle(obstacleType: obstacleTypes[obstacleTypeIndex],
                                    speed: sceneSpeed)
//            obstacle.anchorPoint = CGPoint.zero
            obstacle.position = CGPoint(x: currentXPosition,
                                        y: (ground?.frame.maxY)! * 1.49)
            obstacle.xScale = 0.1
            obstacle.yScale = 0.2
            obstacle.zPosition = 2
            obstacle.calculateSize(windowWidth: frame.width,
                                   windowHeight: frame.height)
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: obstacle.size.width * 0.2,
                height: obstacle.size.height * 0.2))
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.categoryBitMask = CollisionType.obstacle.rawValue
            obstacle.physicsBody?.isDynamic = false
            obstacles.append(obstacle)
            
            currentXPosition = currentXPosition + spaceBetween
            currentXPosition = currentXPosition + CGFloat((extraDistance.randomElement() ?? 0))
        }
        return obstacles
    }
      
}
    

extension GameScene: SetSceneProtocol {
    func addChilds() {
        createSky()
        createGround()
        addChild(player)
        addChild(scoreCounter)
    }
    
    func setPositions() {
        player.calculateSize(windowWidth: frame.height, windowHeight: frame.height)
        let ground = childNode(withName: "image-background")
        player.position = CGPoint(x: frame.minX + 100,
                                  y: (ground?.frame.maxY)! + 30)

        scoreCounter.position = CGPoint(x: self.view!.frame.midX * 1.7, y: self.view!.frame.midY * 1.8)


    }
    
    func setPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
            width: player.size.width * 0.3,
            height: player.size.height * 0.3))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.obstacle.rawValue
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeB = contact.bodyB.node {
            if nodeB.name == "obstacle" {

                //parando o contador
                self.isScoreCounting = false

                //transicionando a scene e atualizando o final score
                let nextScene = GameOverScene(size: self.size)
                let transiton = SKTransition.fade(withDuration: 1.5)
                nextScene.finalScore.text = "\(self.scoreValue)"
                self.view?.presentScene(nextScene, transition: transiton)


                //salvando novo recorde
                if scoreValue > UserDefaults.standard.integer(forKey: "record") {
                    UserDefaults.standard.set(self.scoreValue, forKey: "record")

                }
            }
        }
    }
}
