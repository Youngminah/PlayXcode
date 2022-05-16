//
//  SelectionCell.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit.UICollectionViewCell
import UIKit

final class LanguageCell: UICollectionViewCell {

    static let identifier = "SelectionCell"

    private let nameLabel = UILabel()
    private let nameLocalizedLabel = UILabel()
    private let checkButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String, isChecked: Bool) {
        self.nameLabel.text = text
        self.checkButton.isSelected = isChecked
    }

    func setIsSelectedItem() {
        print(self.checkButton.isSelected)
        self.checkButton.isSelected = !self.checkButton.isSelected
    }

    private func setConstraints() {

        self.addSubview(nameLabel)
//        self.addSubview(nameLocalizedLabel)
        self.addSubview(checkButton)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

//        nameLocalizedLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLocalizedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
//        nameLocalizedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }

    private func setConfiguration() {

        nameLabel.textColor = .label
        nameLabel.numberOfLines = 1

        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkButton.tintColor = .label
    }
}
