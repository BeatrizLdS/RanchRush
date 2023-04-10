//
//  TitleScene.swift
//  RanchRush
//
//  Created by Gabriel Santiago on 10/04/23.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {

    var titleLabel: SKLabelNode = {
        let titleLabel = SKLabelNode()
        titleLabel.fontColor = .blue
        titleLabel.fontSize = 50
        titleLabel.text = "RANCH RUSH"
        titleLabel.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        titleLabel.zPosition = 2
        return titleLabel
    }()

    var recordLabel: SKLabelNode = {
        let recordLabel = SKLabelNode()
        recordLabel.fontColor = .red
        recordLabel.fontSize = 20
        recordLabel.text = "Your record: \(UserDefaults.standard.integer(forKey: "record")) "
        recordLabel.scene?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        recordLabel.zPosition = 3
        return recordLabel
    }()

    override func didMove(to view: SKView) {
        setScene()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let nextScene = GameScene(size: self.size)
        let transition = SKTransition.push(with: .left, duration: 1)
        self.view?.presentScene(nextScene, transition: transition)
    }
}
extension TitleScene: SetSceneProtocol {
    func addChilds() {
        addChild(titleLabel)
        addChild(recordLabel)
    }

    func setPositions() {
        titleLabel.position = CGPoint(x: self.view!.frame.midX , y: self.view!.frame.midY)
        recordLabel.position = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.midY * 0.2)
    }

    func setPhysics() {
        //
    }


}
