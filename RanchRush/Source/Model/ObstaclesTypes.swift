//
//  ObstaclesTypes.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 11/04/23.
//

import Foundation

enum ObstacleState: String {
    case idle = "Idle"
    case attack = "Attack"
}

enum ObstacleType: String {
    case female = "FemaleZombie"
    case male = "MaleZombie"
    case chicken = "Chicken"
    case cow = "Cow"
    case horse = "Horse"
    case sheep = "Sheep"
    case hay = "Hay"
}
