//
//  TitleLabel.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/23.
//

import UIKit.UILabel

open class TextLabel: UILabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    public convenience init(text: String) {
        self.init()
        self.text = text
        self.setConfiguration()
    }

    required public init?(coder: NSCoder) {
        fatalError("TextLabel: fatal Error Message")
    }

    func setConfiguration() {
        self.textColor = .label
        self.font = .systemFont(ofSize: 15, weight: .regular)
    }
}

public final class TitleLabel: TextLabel {

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        fatalError("TitleLabel: fatal Error Message")
    }

    override func setConfiguration() {
        super.setConfiguration()
        self.textColor = .label
        self.font = .systemFont(ofSize: 25, weight: .semibold)
    }
}

public final class SubtitleLabel: TextLabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("SubtitleLabel: fatal Error Message")
    }

    override func setConfiguration() {
        super.setConfiguration()
        self.font = .systemFont(ofSize: 14, weight: .light)
        self.textColor = .gray
        self.numberOfLines = 0
    }
}
