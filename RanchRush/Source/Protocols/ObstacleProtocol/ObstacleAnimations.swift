//
//  ObstacleAnimations.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 05/04/23.
//

import SpriteKit

class ObstacleAnimations: ObstacleAnimationsProtocol {
    var state: ObstacleState
    var frames: [SKTexture]
    
    required init (state: ObstacleState) {
        self.state = state
    }
    
    func loopForever(newState: ObstacleState) {
        <#code#>
    }
    
    func runOneTime(newState: ObstacleState) {
        <#code#>
    }
    
    
}
