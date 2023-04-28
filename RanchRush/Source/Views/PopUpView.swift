//
//  PopUpView.swift
//  RanchRush
//
//  Created by Beatriz Leonel da Silva on 28/04/23.
//

import UIKit

class PopUpView: UIView {

    var delegate: PauseProtocol?
    private var buttonRadius: CGFloat = 70
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Game paused"
        label.font = UIFont(name: "Small-Pixel", size: 40)
        label.textColor = .gameGreen
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private let resumeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .white
        button.clipsToBounds = true
        let size = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .medium)
        button.setImage(UIImage(systemName: "play.fill",
                                withConfiguration: size),
                        for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var popUpStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, resumeButton])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    } ()
    
    private var content: UIView = {
        let view = UIView()
        view.backgroundColor = .pauseBackground
        view.layer.cornerRadius = 50
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.gameGreen.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        backgroundColor = .black.withAlphaComponent(0.5)
        buildLayoutSubviews()
        resumeButton.addTarget(self, action: #selector(closeAnimation), for: .touchUpInside)
        openAnimation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.alpha = 0
        } completion: { finish in
            if finish {
                self.removeFromSuperview()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.gameResume()
        }
    }
    
    @objc private func openAnimation() {
        self.alpha = 0
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    
}

extension PopUpView: SetViewProtocol {
    func setupSubviews() {
        content.addSubview(popUpStack)
        self.addSubview(content)
        
    }
    
    func setupConstraints() {
        let contentConstraints = [
            content.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            content.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            content.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6),
            content.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7)
        ]
        let popUpStackConstraints = [
            popUpStack.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            popUpStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popUpStack.widthAnchor.constraint(equalTo: content.widthAnchor, multiplier: 0.9),
            popUpStack.heightAnchor.constraint(equalTo: content.heightAnchor, multiplier: 0.8)
        ]
        NSLayoutConstraint.activate(contentConstraints)
        NSLayoutConstraint.activate(popUpStackConstraints)
        resumeButton.heightAnchor.constraint(equalToConstant: buttonRadius).isActive = true
        resumeButton.layer.cornerRadius = buttonRadius/2
    }
}
