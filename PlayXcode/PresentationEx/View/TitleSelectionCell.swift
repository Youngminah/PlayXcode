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
}

final class TitleCell: SelectionCollectionViewCell {

    override class var identifier: String {
        return "TitleCell"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didSelectConfigure() {

    }

    private func setConstraints() {
        self.addSubview(textLabel)
    }

    private func setConfiguration() {
        textLabel.textColor = .label
        textLabel.numberOfLines = 1
    }
}


final class TitleSelectionCell: SelectionCollectionViewCell {

    override class var identifier: String {
        return "TitleSelectionCell"
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

        contentView.addSubview(checkButton)
        contentView.addSubview(textLabel)

        checkButton.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                  constant: -16),
            checkButton.widthAnchor.constraint(equalToConstant: 20),
            checkButton.heightAnchor.constraint(equalToConstant: 20),

            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor,
                                                constant: -16)
        ])
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
