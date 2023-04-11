//
//  PlayerAnimationsProtocol.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 05/04/23.
//

import SpriteKit

protocol PlayerAnimationsProtocol: CharacterAnimationsProtocol where
Image == SKTexture,
State == PlayerStates {}
