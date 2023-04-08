//
//  GameScene.swift
//  RanchRush
//
//  Created by Thaynara da Silva Andrade on 04/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    let player: Player = {
        let player = Player()
        player.setFrames()
        player.anchorPoint = CGPoint.zero
        player.zPosition = 2
        player.xScale = 0.3
        player.yScale = 0.3
        return player
    } ()
    
    let obstacleTypes: [ObstacleType] = [.female, .male]
    var numberObstacles = 5
    var sceneSpeed: CGFloat = 1
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint.zero
        backgroundColor = UIColor(named: "background")!
        addSwipeGestureRecognizer()
        player.loopForever(state: .run)
        setScene()
    }

    override func update(_ currentTime: CFTimeInterval) {
        moveGround()
        moveSky()

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
            obstacle.anchorPoint = CGPoint.zero
            obstacle.position = CGPoint(x: currentXPosition,
                                        y: (ground?.frame.maxY)!)
            obstacle.xScale = 0.1
            obstacle.yScale = 0.2
            obstacle.zPosition = 2
            obstacle.calculateSize(windowWidth: frame.width,
                                   windowHeight: frame.height)
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
    }
    
    func setPositions() {
        player.calculateSize(windowWidth: frame.height, windowHeight: frame.height)
        let ground = childNode(withName: "image-background")
        player.position = CGPoint(x: frame.minX + 10,
                                  y: (ground?.frame.maxY)! - 10)
        player.zPosition = 2
    }
    
    func setPhysics() { }
    
}
