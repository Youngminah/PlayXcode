//
//  ContentView.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

class ContentCollectionView: UICollectionView {

    var items = [
        SelectionItem(name: "한국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "중국어")
    ]

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = .systemBackground
        //sheetContainerView?.backgroundColor = .systemBackground
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


//class BaseItem {
//
//    let text: String
//
//    init(text: String) {
//        self.text = text
//    }
//}

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

class CheckBoxItem: Hashable {

    let text: String = ""
    var isChecked: Bool = true
    private let identifier = UUID()

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: CheckBoxItem, rhs: CheckBoxItem) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.isChecked == rhs.isChecked
    }
}

protocol HashableType: Hashable {

    var identifier: String { get set }
}

extension HashableType {

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

struct SelectionItem: HashableType {

    let name: String
    var identifier = UUID().uuidString
}

//final class ContentSelectionItem<T>: SelectionItem {
//
//    let content: T
//
//    init(name: String, isSelected: Bool, content: T) {
//        self.content = content
//        super.init(name: name, isSelected: isSelected)
//    }
//}


