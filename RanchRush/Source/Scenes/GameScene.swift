//
//  GameScene.swift
//  RanchRush
//
//  Created by Thaynara da Silva Andrade on 04/04/23.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene {

    var popUp: PopUpView?
    
    var realPaused = false {
        didSet {
            isPaused = realPaused
        }
    }
    
    override var isPaused: Bool {
        didSet {
            if (self.realPaused != self.isPaused) {
                self.isPaused = self.realPaused
            }
        }
    }
    
    var scoreValue = 0{
        didSet{
            scoreCounter.text = "SCORE: \(scoreValue)"
        }
    }

    var audioPlayer: AVAudioPlayer?
    var isScoreCounting: Bool = true
    var canJump: Bool = true
    var isMusicPlaying = true

    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    let player: Player = {
        let player = Player()
        player.setFrames()
        player.anchorPoint = CGPoint(x: 0.46, y: 0.2)
        player.zPosition = 2
        player.xScale = 0.5
        player.yScale = 0.5
        return player
    } ()

    var scoreCounter: SKLabelNode = {
        let scoreCounter = SKLabelNode()
        scoreCounter.scene?.anchorPoint = CGPoint(x: 1, y: 1)
        scoreCounter.fontSize = 20
        scoreCounter.fontColor = .systemYellow
        scoreCounter.zPosition = 3
        scoreCounter.fontName = "Small-Pixel"
        return scoreCounter
    }()
    
    var pauseButton: SKSpriteNode = {
        let size = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "pause", withConfiguration: size)?.withTintColor(.black)
        let button = SKSpriteNode(texture: SKTexture(image: image!))
        let shape = SKShapeNode(circleOfRadius: 22)
        shape.fillColor = .white
        shape.strokeColor = .clear
        button.addChild(shape)
        button.zPosition = 3
        return button
    }()

    let obstacleTypes: [ObstacleType] = [.hay, .chicken, .cow, .horse, .sheep]
    var numberObstacles = 5
    var sceneSpeed: CGFloat = 4

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        let touchLocation = touch.location(in: self)
        
        if pauseButton.contains(touchLocation) {
            if isPaused {
                startGame()
                audioPlayer?.play()
            } else {
                pauseGame()
            }
        } else if isPaused ==  false {
            playerJump()
        }
    }
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.zero
        backgroundColor = .gameBackground
        player.loopForever(state: .idle)
        setScene()
        self.physicsWorld.contactDelegate = self
        if isMusicPlaying == true {
            playSound(name: "RanchRushCroppedThree", extension: "wav")
        }
        startGame()
    }

    override func update(_ currentTime: CFTimeInterval) {
        moveGround()
        moveSky()
        if isScoreCounting == true {
            scoreValue += 1
        }
        
        let activateScenario = children.compactMap{ $0 as? Scenario }
        let activeObstacles = children.compactMap{ $0 as? Obstacle }
        removeOffScreen(list: activateScenario)
        removeOffScreen(list: activeObstacles)
        
        let startingScenario = activateScenario.compactMap{ $0.scenarioType == .starting }
        if activeObstacles.isEmpty && startingScenario.isEmpty {
            createObstacles()
            if numberObstacles < 30 {
                numberObstacles += 2
            }
        }
    }
    
    func playerJump() {
        if self.canJump == true {
            player.jump()
            player.run(SKAction.applyImpulse(CGVector(dx: 0, dy: frame.height * 0.3), duration: 0.2))
            self.canJump = false
        }
    }
    
    func removeOffScreen(list: [SKNode]) {
        for child in list {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
    }
    
    func createObstacles() {
        let obstacleOffsetx: CGFloat = player.frame.width
        
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
            let ground = SKSpriteNode(imageNamed: "screengame-ground")
            ground.name = "screengame-ground"
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
            ground.physicsBody?.categoryBitMask = CollisionType.ground.rawValue
            self.addChild(ground)
        }
    }
    
    func createSky(){
        for i in 0...3{
            let sky = SKSpriteNode(imageNamed: "screengame-sky")
            sky.name = "screengame-sky"
            sky.xScale = 1
            sky.yScale = 1
            sky.calculateSize(windowWidth: frame.width, windowHeight: frame.height)
            sky.anchorPoint = CGPoint.zero
            sky.zPosition = -1
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width,
                                   y: frame.minY)
            self.addChild(sky)
        }
    }
    
    func createInitialScenario() {
        let barn = Scenario(objectType: .barn, scenarioType: .starting, speed: sceneSpeed)
        let rightFance = Scenario(objectType: .fance, scenarioType: .starting, side: .right, speed: sceneSpeed)
        let leftFance = Scenario(objectType: .fance, scenarioType: .starting, side: .left, speed: sceneSpeed)
        let tree = Scenario(objectType: .tree, scenarioType: .starting, speed: sceneSpeed)
        let objects = [barn, rightFance, leftFance, tree]
        for object in objects {
            addChild(object)
        }
    }
    
    func setPositionInicialScenario() {
        let startScenario = children.compactMap{ $0 as? Scenario }
        let ground = childNode(withName: "screengame-ground")
        for object in startScenario {
            object.zPosition = 1
            object.generateSize(
                width: frame.width,
                height: frame.height
            )
            object.generatePosition(
                x: frame.maxX,
                y: (ground?.frame.maxY)!
            )
        }
    }
    
    func moveGround() {
        enumerateChildNodes(withName: "screengame-ground") { node, error in
            node.position.x -= self.sceneSpeed
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3
                
            }
        }
    }
    
    func moveSky() {
        enumerateChildNodes(withName: "screengame-sky") { node, error in
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
        let ground = childNode(withName: "screengame-ground")
        
        for _ in 0...(numberObstacles-1) {
            obstacleTypeIndex = Int.random(in: 0..<obstacleTypes.count)
            let obstacle = Obstacle(
                obstacleType: obstacleTypes[obstacleTypeIndex],
                speed: sceneSpeed
            )
            obstacle.zPosition = 2
            obstacle.anchorPoint = CGPoint(x: 0.5, y: 0.25)
            obstacle.generatePosition(
                x: currentXPosition,
                y: (ground?.frame.maxY)!
            )
            obstacle.generateSize(
                width: frame.width,
                height: frame.height
            )
            obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: obstacle.size.width * 0.4,
                height: obstacle.size.height * 0.36))
            obstacle.physicsBody?.affectedByGravity = false
            obstacle.physicsBody?.categoryBitMask = CollisionType.obstacle.rawValue
            obstacle.physicsBody?.isDynamic = false
            obstacles.append(obstacle)
            
            currentXPosition = currentXPosition + spaceBetween
            currentXPosition = currentXPosition + CGFloat((extraDistance.randomElement() ?? 0))
        }
        return obstacles
    }
    
    func pauseGame() {
        audioPlayer?.pause()
        popUp = PopUpView()
        popUp!.delegate = self
        self.view?.addSubview(popUp!)
        self.realPaused = true
    }
    
    func startGame() {
        pauseButton.position = CGPoint(x: frame.minX + (frame.width * 0.08), y: frame.maxY * 0.9)
        self.realPaused = false
    }
      
}
    

extension GameScene: SetSceneProtocol {
    func addChilds() {
        createSky()
        createGround()
        addChild(player)
        addChild(scoreCounter)
        createInitialScenario()
        addChild(pauseButton)
    }
    
    func setPositions() {
        player.calculateSize(windowWidth: frame.height, windowHeight: frame.height)
        let ground = childNode(withName: "screengame-ground")
        player.position = CGPoint(x: frame.minX + 100,
                                  y: (ground?.frame.maxY)! + 30)

        scoreCounter.position = CGPoint(x: frame.midX * 1.7, y: frame.maxY * 0.9)
        setPositionInicialScenario()
    }
    
    func setPhysics() {
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
            width: player.size.width * 0.3,
            height: player.size.height * 0.3))
        player.physicsBody?.categoryBitMask = CollisionType.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionType.obstacle.rawValue | CollisionType.ground.rawValue
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        if let nodeB = contact.bodyB.node, let nodeA = contact.bodyA.node {
            if nodeB.name == "obstacle" {

                //parado a música
                audioPlayer?.stop()

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
            if nodeA.name == "screengame-ground" {
                self.canJump = true
            }
        }
    }
}

extension GameScene: PauseProtocol {
    func gameResume() {
        startGame()
    }
}
