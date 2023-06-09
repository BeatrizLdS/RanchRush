//
//  GameViewController.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 03/04/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = TitleScene(size: view.bounds.size)
        let skView = self.view as! SKView
        skView.contentMode = .scaleAspectFill
        skView.presentScene(scene)
        // Information in screen corner
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        skView.showsPhysics = false
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
