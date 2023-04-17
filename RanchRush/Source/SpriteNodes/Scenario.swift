//
//  Scenario.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 12/04/23.
//

import SpriteKit

enum Side: String {
    case right = "right"
    case left = "left"
}

class Scenario: SKSpriteNode {
    private var objectType: ScenarioObjectsType
    var scenarioType: ScenarioType
    var side: Side?
    private var velocity: CGFloat
    
    init(objectType: ScenarioObjectsType, scenarioType: ScenarioType, side: Side? = nil, speed: CGFloat) {
        self.objectType = objectType
        self.scenarioType = scenarioType
        self.side = side
        self.velocity = speed
        super.init(texture: SKTexture(imageNamed: objectType.rawValue), color: .clear, size: .zero)
        configureMovement()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func generateSize(width: CGFloat, height: CGFloat) {
        switch objectType {
        case .barn:
            zPosition = 0
            xScale = 0.5
            yScale = 1.2
        case .fance:
            xScale = 0.2
            yScale = 0.2
        case .tractor:
            xScale = 1
            yScale = 1
        case .tree:
            xScale = 0.2
            yScale = 0.4
        }
        calculateSize(
            windowWidth: width,
            windowHeight: height
        )
    }
    
    func generatePosition(x: CGFloat, y: CGFloat) {
        var multiplierY: CGFloat = 0
        var newX = x
        switch objectType {
        case .barn:
            anchorPoint = CGPoint(x: 0.85, y: 0)
        case .fance:
            if scenarioType == .starting {
                if side == .right {
                    anchorPoint = CGPoint(x: 0.75, y: 0)
                    multiplierY = 1
                }
                else if side == .left {
                    anchorPoint = CGPoint(x: 0.25, y: 0)
                    multiplierY = 1
                    newX = 0
                }
            }
        case .tractor:
            multiplierY = 1.5
        case .tree:
            if scenarioType == .starting {
                zPosition = 0
                anchorPoint = CGPoint(x: 0.5, y: 0.25)
                multiplierY = 1.5
                newX = newX * 0.19
            }
        }
        position = CGPoint(
            x: newX,
            y: y * multiplierY
        )
    }
}
