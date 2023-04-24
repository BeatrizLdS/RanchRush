//
//  SKSceneExtension.swift
//  RanchRush
//
//  Created by Gabriel Santiago on 12/04/23.
//

import Foundation
import AVFoundation
import SpriteKit

extension GameScene {
    func playSound(name: String, extension: String){

        let url = Bundle.main.url(forResource: name, withExtension: `extension`)
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer?.play()
        } catch {
            print(error)
        }
    }

}
