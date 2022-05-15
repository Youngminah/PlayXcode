//
//  XButton.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit.UIButton

final class XButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("XButton: fatal Error Message")
    }

    private func setConfiguration() {
        self.setImage(UIImage(systemName: "xmark"), for: .normal)
        self.tintColor = .label
    }
}
