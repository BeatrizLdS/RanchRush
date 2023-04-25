//
//  GameOverScene.swift
//  RanchRush
//
//  Created by Gabriel Santiago on 10/04/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var backgroundFinal = SKSpriteNode(imageNamed: "screen-final")

    var finalScore: SKLabelNode = {
        let finalScore = SKLabelNode()
        finalScore.text = "PLACEHOLDER"
        finalScore.fontColor = .white
        finalScore.fontSize = 50
        finalScore.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        finalScore.zPosition = 3
        finalScore.fontName = "Small-Pixel"
        return finalScore
    }()

    var labelFinal: SKLabelNode = {
        let labelFinal = SKLabelNode()
        labelFinal.text = ""
        labelFinal.fontColor = .white
        labelFinal.fontSize = 10
        labelFinal.scene?.anchorPoint = CGPoint(x: 1, y: 1)
        labelFinal.zPosition = 3
        labelFinal.fontName = "Small-Pixel"
        return labelFinal
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
        addChild(labelFinal)
        addChild(backgroundFinal)
    }

    func setPositions() {
        finalScore.position = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY * 1.6)
        labelFinal.position = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY * 1.1)
        backgroundFinal.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundFinal.zPosition = -1
    }

    func setPhysics() {
        //
    }
}

