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
    case female = "Female"
    case male = "Male"
}

class Obstacle: SKSpriteNode {
    private var obstacleType: ObstacleType
    private lazy var frames: [SKTexture] = []
    private var state: ObstacleState = .idle
    private var velocity: CGFloat

    init(obstacleType: ObstacleType, startPosition: CGPoint, xOffset: CGFloat, speed: CGFloat) {
        self.obstacleType = obstacleType
        self.velocity = speed
        super.init(texture: SKTexture(imageNamed: "zombie"), color: .white, size: .zero)
        setObstacle(startPosition: startPosition, xOffset: xOffset)
        configureMovement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFrames () {
        let newFrames = getFrames(with: state.rawValue, atlasName: "\(obstacleType.rawValue)Zombie")
        if newFrames.isEmpty == false {
            frames = newFrames
            texture = frames[0]
        }
    }
    
    func configureMovement() {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: -100, y: 0))
        
        let movement = SKAction.follow(
            path.cgPath,
            asOffset: true,
            orientToPath: false,
            speed: velocity
        )
        run(movement)
    }
}

extension Obstacle: SetObstacleProtocol {
    func setPosition(startPosition: CGPoint, xOffset: CGFloat) {
        position = CGPoint(x: startPosition.x + xOffset, y: startPosition.y)
    }
    
    func setPhysics() {
        setFrames()
    }
}
