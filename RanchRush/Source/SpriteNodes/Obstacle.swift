//
//  Obstacle.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 04/04/23.
//

import SpriteKit

enum ObstacleState: String {
    case idle = "Idle"
    case attack = "Attack"
}

enum ObstacleType: String {
    case female = "FemaleZombie"
    case male = "MaleZombie"
    case chicken = "Chicken"
    case cow = "Cow"
    case horse = "Horse"
    case sheep = "Sheep"
    case hay = "Hay"
}

class Obstacle: SKSpriteNode {
    private var state: ObstacleState = .idle
    private var frames: [SKTexture] = []
    private var obstacleType: ObstacleType
    private var velocity: CGFloat

    init(obstacleType: ObstacleType, speed: CGFloat) {
        self.obstacleType = obstacleType
        self.velocity = speed
        super.init(texture: SKTexture(imageNamed: "zombie"), color: .white, size: .zero)
        configureMovement()
        loopForever(newState: .idle)
        name = "obstacle"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFrames () {
        let newFrames = getFrames(with: state.rawValue, atlasName: "\(obstacleType.rawValue)")
        if newFrames.isEmpty == false {
            frames = newFrames
            texture = frames[0]
        }
    }
    
    func configureMovement() {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: -1000000,
                                 y: 0))
        
        let movement = SKAction.follow(
            path.cgPath,
            asOffset: true,
            orientToPath: false,
            speed: velocity * 58
        )
        run(movement)
    }
    
    func loopForever(newState: ObstacleState) {
        self.state = newState
        setFrames()
        let action = SKAction.animate(with: frames,
                                      timePerFrame: 1 / TimeInterval(frames.count),
                                      resize: false,
                                      restore: true)
        run(SKAction.repeatForever(action))
    }
    
    func runOneTime(newState: ObstacleState) {
        self.state = newState
        setFrames()
        let action = SKAction.animate(with: frames,
                                      timePerFrame: 1/TimeInterval(frames.count),
                                      resize: false,
                                      restore: false)
        action.timingMode = .linear
        run(action)
    }
    
    func generateSize(width: CGFloat, height: CGFloat) {
        switch obstacleType {
        case .female:
            yScale = 0.2
            xScale = 0.1
        case .male:
            yScale = 0.2
            xScale = 0.1
        case .chicken:
            xScale = 0.05
            yScale = 0.1
        case .cow:
            xScale = 0.08
            yScale = 0.2
        case .horse:
            xScale = 0.1
            yScale = 0.25
        case .sheep:
            xScale = 0.1
            yScale = 0.2
        case .hay:
            xScale = 0.08
            yScale = 0.2
        }
        calculateSize(
            windowWidth: width,
            windowHeight: height
        )
    }
    
    func generatePosition(x: CGFloat, y: CGFloat) {
        var multiplierY: CGFloat = 0
        switch obstacleType {
        case .female:
            multiplierY = 1.49
        case .male:
            multiplierY = 1.49
        case .chicken:
            multiplierY = 1.2
        case .cow:
            multiplierY = 1.5
        case .horse:
            multiplierY = 1.6
        case .sheep:
            multiplierY = 1.35
        case .hay:
            multiplierY = 1.5
        }
        position = CGPoint(
            x: x,
            y: y * multiplierY
        )
    }
    
}
