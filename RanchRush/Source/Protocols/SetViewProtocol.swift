//
//  File.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 28/04/23.
//

import Foundation

public protocol SetViewProtocol {
    func setupSubviews()
    func setupConstraints()
}

extension SetViewProtocol {
    func buildLayoutSubviews() {
        setupSubviews()
        setupConstraints()
    }
}
