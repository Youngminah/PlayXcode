//
//  SelectionCell.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit.UICollectionViewCell

//protocol ReuseIdentifierType {
//    static var identifier: String { get }
//}

class SelectionCollectionViewCell: UICollectionViewCell {


    class var identifier: String {
        return "SelectionCollectionViewCell"
    }
    let textLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            self.didSelectConfigure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(text: String) {
        self.textLabel.text = text
    }

    func didSelectConfigure() { }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        //self.backgroundColor = .yellow
    }
}

final class LanguageCell: SelectionCollectionViewCell {

    override class var identifier: String {
        return "LanguageCell"
    }

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

    override func didSelectConfigure() {
        self.checkButton.isSelected = self.isSelected
    }

    private func setConstraints() {

        self.addSubview(textLabel)
//        self.addSubview(nameLocalizedLabel)
        self.addSubview(checkButton)

        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

//        nameLocalizedLabel.translatesAutoresizingMaskIntoConstraints = false
//        nameLocalizedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5).isActive = true
//        nameLocalizedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true

        checkButton.translatesAutoresizingMaskIntoConstraints = false
        checkButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }

    private func setConfiguration() {

        textLabel.textColor = .label
        textLabel.numberOfLines = 1

        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkButton.isUserInteractionEnabled = false
        checkButton.tintColor = .label
    }
}
