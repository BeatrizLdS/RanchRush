//
//  AppDelegate.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 03/04/23.
//

import UIKit
import SpriteKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let skView = self.window?.rootViewController?.view as? SKView else { return }
        if let skScene = skView.scene as? GameScene {
            skScene.pauseGame()
        }
    }

}

