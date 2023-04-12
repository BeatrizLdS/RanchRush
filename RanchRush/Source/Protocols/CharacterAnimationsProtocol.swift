//
//  CharacterAnimationsProtocol.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 05/04/23.
//

protocol CharacterAnimationsProtocol {
    associatedtype Image
    associatedtype State
    var state: State { get set }
    var frames: [Image] { get set }
    func loopForever(newState: State)
    func runOneTime(newState: State)
}
