//
//  GameScene.swift
//  RanchRush
//
//  Created by Thaynara da Silva Andrade on 04/04/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ground = SKSpriteNode()
    var sky = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 1, y: 1)
        backgroundColor = UIColor(named: "background")!
        setScene()
    }

    override func update(_ currentTime: CFTimeInterval) {
        moveGround()
        moveSky()
    }
    
    func createGround(){
        for i in 0...3{

            let ground = SKSpriteNode(imageNamed: "image-background")
            ground.name = "image-background"
            ground.size = CGSize(width: (self.scene?.size.width)!, height: 0.3)
            ground.anchorPoint = CGPoint(x: 1, y: 2)
            ground.zPosition = 2
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: -(self.frame.size.height / 2))
            self.addChild(ground)
        }
    }
    
    func createSky(){
        
        for i in 0...3{
            let sky = SKSpriteNode(imageNamed: "image-sky")
            sky.name = "image-sky"
            sky.size = CGSize(width: frame.width, height: frame.height)
            sky.anchorPoint = CGPoint(x: 1, y: 0.5)
            sky.zPosition = 1
            sky.position = CGPoint(x: CGFloat(i) * sky.size.width, y: -(self.frame.size.height / 2))
            self.addChild(sky)
        }
    }
    
    func moveGround() {
        
        enumerateChildNodes(withName: "image-background") { node, error in
            node.position.x -= 0.002
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3

            }
        }
        
    }
    
    func moveSky() {
        
        enumerateChildNodes(withName: "image-sky") { node, error in
            node.position.x -= 0.0005
            if node.position.x < -((self.scene?.size.width)!) {
                node.position.x += (self.scene?.size.width)! * 3

            }
        }
        
    }
}

extension GameScene: SetSceneProtocol {
    func addChilds() {
        createSky()
        createGround()
    }
    
    func setPositions() {
    }
    
    func setPhysics() {
    }
    
    
}
