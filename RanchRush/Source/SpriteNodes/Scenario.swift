//
//  Scenario.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 12/04/23.
//

import SpriteKit

class Scenario: SKSpriteNode {
    private var objectType: ScenarioObjectsType
    var scenarioType: ScenarioType
    
    init(objectType: ScenarioObjectsType, scenarioType: ScenarioType) {
        self.objectType = objectType
        self.scenarioType = scenarioType
        super.init(texture: SKTexture(imageNamed: objectType.rawValue), color: .clear, size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func generate
}
