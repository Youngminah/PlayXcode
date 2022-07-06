//
//  SelectionCell.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit.UICollectionViewCell
import QDSKit

protocol BottomSheetCell: UICollectionViewCell {

    associatedtype Item: BottomSheetItem

    static var identifier: String { get }

    func configure(item: Item)
    func didSelectConfigure()
}

final class TitleCell: UICollectionViewCell, BottomSheetCell {

    class var identifier: String {
        return "TitleCell"
    }

    private let textLabel = UILabel()

    override var isSelected: Bool {
        didSet {
            self.didSelectConfigure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didSelectConfigure() {
        contentView.backgroundColor = isSelected ? QDS.Color.orangeOffwhite : .systemBackground
        textLabel.font = isSelected ? QDS.Font.b2 : QDS.Font.b3
    }

    private func setConstraints() {

        contentView.addSubview(textLabel)

        textLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 16),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -16)
        ])
    }

    private func setConfiguration() {
        contentView.backgroundColor = .systemBackground

        textLabel.font = QDS.Font.b3
        textLabel.highlightedTextColor = QDS.Color.orange
        textLabel.textColor = QDS.Color.gray100
        textLabel.numberOfLines = 1
    }

    func configure(item: ListItem) {
        self.textLabel.text = item.name
    }
}


final class TitleSelectionCell: UICollectionViewCell, BottomSheetCell {

    static var identifier: String {
        return "TitleSelectionCell"
    }

    private let textLabel = UILabel()
    private let checkButton = UIButton()

    override var isSelected: Bool {
        didSet {
            self.didSelectConfigure()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
        setConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func didSelectConfigure() {
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
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.backgroundColor = .yellow

        textLabel.textColor = .label
        textLabel.numberOfLines = 1

        checkButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkButton.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkButton.isUserInteractionEnabled = false
        checkButton.tintColor = .label
    }

    func configure(item: ListItem) {
        self.textLabel.text = item.name
    }
}

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
