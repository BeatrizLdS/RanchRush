//
//  SetObstacleProtocol.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 04/04/23.
//

import Foundation

protocol SetObstacleProtocol {
    func setPosition(startPosition: CGPoint, xOffset: CGFloat)
    func setPhysics()
}

extension SetObstacleProtocol {
    func setObstacle(startPosition: CGPoint, xOffset: CGFloat) {
        setPosition(startPosition: startPosition, xOffset: xOffset)
        setPhysics()
    }
}
