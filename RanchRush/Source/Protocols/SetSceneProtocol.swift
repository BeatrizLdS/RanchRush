//
//  SetSceneProtocol.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 03/04/23.
//

import Foundation

protocol SetSceneProtocol {
    func addChilds()
    func setPositions()
    func setPhysics()
}

extension SetSceneProtocol {
    func setScene() {
        addChilds()
        setPositions()
        setPhysics()
    }
}
