//
//  Player.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 04/04/23.
//

import SpriteKit

enum PlayerStates: String {
    case run = "Run"
    case idle = "Idle"
    case jump = "Jump"
    case dead = "Dead"
}

class Player: SKSpriteNode {
    private var frames: [SKTexture] = []
    private var state: PlayerStates = .idle
    
    func setFrames() {
        let atlasName = "Player\(state.rawValue)"
        let newFrames = getFrames(with: state.rawValue, atlasName: atlasName)
        if  newFrames.isEmpty == false {
            self.frames = newFrames
            self.texture = self.frames[0]
        }
    }
    
    func jump() {
        runOneTime(state: .jump)
    }
    
    func dead() {
        runOneTime(state: .dead)
    }
    
    func loopForever(state: PlayerStates) {
        self.state = state
        setFrames()
        let action = SKAction.animate(with: frames,
                                      timePerFrame: 1 / TimeInterval(frames.count),
                                      resize: false,
                                      restore: true)
        run(SKAction.repeatForever(action))
    }
    
    func runOneTime(state: PlayerStates) {
        self.state = state
        setFrames()
        let action = SKAction.animate(with: frames,
                                      timePerFrame: 1/TimeInterval(frames.count),
                                      resize: false,
                                      restore: false)
        action.timingMode = .linear
        run(action)
    }
}
