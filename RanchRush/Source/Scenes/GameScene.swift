//
//  GameScene.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 03/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let player: Player = {
        let player = Player()
        player.setFrames()
        player.anchorPoint = CGPoint.zero
        player.xScale = 0.25
        player.yScale = 0.5
        return player
    } ()
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        setScene()
        addSwipeGestureRecognizer()
        player.loopForever(state: .run)
        player.runOneTime(state: .idle)
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
    
    override func sceneDidLoad() {
    }
    
    override func update(_ currentTime: TimeInterval) {
    }
}

extension GameScene: SetSceneProtocol {
    func addChilds() {
        addChild(player)
    }
    
    func setPositions() {
        player.calculateSize(windowWidth: frame.height, windowHeight: frame.height)
        player.position = CGPoint(x: frame.minX + 0.07, y: frame.minY + 0.05)
    }
    
    func setPhysics() {
    }
    
}
