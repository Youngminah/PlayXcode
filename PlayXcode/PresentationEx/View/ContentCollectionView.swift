//
//  ContentView.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

class ContentCollectionView: UICollectionView {

    var items = [
        CheckBoxItem(text: "한국어", isChecked: true),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false)
    ]

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        //self.register(LanguageCell.self, forCellWithReuseIdentifier: LanguageCell.identifier)
        //self.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension ContentCollectionView: UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LanguageCell.identifier, for: indexPath as IndexPath) as! LanguageCell
//        cell.setIsSelectedItem()
//    }
//}


class BaseItem {

    let text: String

    init(text: String) {
        self.text = text
    }
}

//final class CheckBoxItem: BaseItem, Hashable {
//
//    let isChecked: Bool
//    private let identifier = UUID()
//
//    init(text: String, isChecked: Bool) {
//        self.isChecked = isChecked
//        super.init(text: text)
//    }
//}

struct CheckBoxItem: Hashable {

    let text: String
    var isChecked: Bool
    private let identifier = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: CheckBoxItem, rhs: CheckBoxItem) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.isChecked == rhs.isChecked
    }
}
