//
//  BadgeView.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/26.
//

import UIKit

final class BadgeView: UICollectionReusableView {
    
    static let identifier = "BadgeView"
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.addSubview(button)
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 40),
            self.button.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
