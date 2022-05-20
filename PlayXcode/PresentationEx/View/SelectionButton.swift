//
//  SelectionButton.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit.UIButton

final class SelectionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(title: String) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("SelectionButton: fatal Error Message")
    }

    private func setConfiguration() {
        self.setTitleColor(.white, for: .normal)
        self.backgroundColor = .orange
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
}
