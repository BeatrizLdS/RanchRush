//
//  SpriteNodeExtension.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 04/04/23.
//

import SpriteKit

extension SKSpriteNode {
    func getFrames(with name: String, atlasName: String) -> [SKTexture]? {
        let atlas = SKTextureAtlas(named: atlasName)
        var frames: [SKTexture] = []
        
        let allFrameNames = atlas.textureNames.sorted()
        for frameName in allFrameNames {
            if frameName.contains(name) {
                let frame = atlas.textureNamed(frameName)
                frames.append(frame)
            }
        }
        return frames
    }
    func calculateSize(windowWidth: CGFloat, windowHeight: CGFloat) {
        self.size = CGSize(width: windowWidth * self.xScale,
                           height: windowHeight * self.yScale)
    }
}
