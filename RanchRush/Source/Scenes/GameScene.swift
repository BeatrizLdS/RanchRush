//
//  GameScene.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 03/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let obstacleTypes: [ObstacleType] = [.female, .male]
    var numberObstacles = 5
    var obstaclesSpeed: CGFloat = 0.1
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
    }
    
    override func sceneDidLoad() {
    }
    
    override func update(_ currentTime: TimeInterval) {
        let activeObstacles = children.compactMap{ $0 as? Obstacle}
        
        for child in activeObstacles {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        if activeObstacles.isEmpty {
            createObstacles()
            numberObstacles += 2
            if obstaclesSpeed < 1 {
                obstaclesSpeed += 0.05
            }
        }
    }
    
    func createObstacles() {
        let obstacleOffsetx: CGFloat = 0.4
        let obstacleStartX: Double = 0.5
        
        generateRandomObstacles(
            startX: obstacleStartX,
            spaceBetween: obstacleOffsetx,
            numberObstacles: self.numberObstacles
        )
    }
    
    func generateRandomObstacles(startX: Double, spaceBetween: CGFloat, numberObstacles: Int) {
        var obstacletypeIndex = Int.random(in: 0..<obstacleTypes.count)
        let positions = Array(stride(from: 0.05, to: 0.5, by: 0.05)) // posições dos inimigos

        for index in 0...numberObstacles {
            obstacletypeIndex = Int.random(in: 0..<obstacleTypes.count)
            let space = spaceBetween * CGFloat(index) + (positions.randomElement() ?? 0)
            
            let startPosition = CGPoint(x: frame.maxX, y: frame.minY + 0.1)
            let obstacle = Obstacle(obstacleType: obstacleTypes[obstacletypeIndex],
                                    startPosition: startPosition,
                                    xOffset: space,
                                    speed: obstaclesSpeed)
            obstacle.xScale = 0.1
            obstacle.yScale = 0.3
            obstacle.calculateSize(windowWidth: frame.width, windowHeight: frame.height)
            obstacle.anchorPoint = .zero
            addChild(obstacle)
        }
    }
}
