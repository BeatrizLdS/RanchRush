//
//  GameOverScene.swift
//  RanchRush
//
//  Created by Gabriel Santiago on 10/04/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {

    var finalScore: SKLabelNode = {
        let finalScore = SKLabelNode()
        finalScore.text = "PLACEHOLDER"
        finalScore.fontColor = .systemRed
        finalScore.fontSize = 50
        finalScore.scene?.anchorPoint = CGPoint(x: 1, y: 1)
        finalScore.zPosition = 3
        return finalScore
    }()

    override func didMove(to view: SKView) {
        setScene()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextScene = TitleScene(size: self.size)
        let transition = SKTransition.fade(withDuration: 1)
        self.view?.presentScene(nextScene, transition: transition)
    }

}
extension GameOverScene: SetSceneProtocol {
    func addChilds() {
        addChild(finalScore)
    }

    func setPositions() {
        finalScore.position = CGPoint(
            x: self.view!.frame.midX,
            y: self.view!.frame.midY)
    }

    func setPhysics() {
        //
    }
}

