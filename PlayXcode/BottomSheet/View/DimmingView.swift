//
//  DimmingView.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

final class DimmingView: UIView {
    
    var didTap: ((_ recognizer: UIGestureRecognizer) -> Void)?
    
    private lazy var tapGesture: UIGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(didTapView))
    }()
    
    init(dimmingColor: UIColor = .black.withAlphaComponent(0.7)) {
        super.init(frame: .zero)
        alpha = 0.0
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = dimmingColor
        addGestureRecognizer(tapGesture)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapView() {
        didTap?(tapGesture)
    }
}
