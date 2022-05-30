//
//  ContentView.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

class ContentCollectionView: UICollectionView {

    var items = [
        ListItem(name: "한국어"),
        ListItem(name: "중국어"),
        ListItem(name: "중국어"),
        ListItem(name: "중국어"),
        ListItem(name: "중국어"),
        ListItem(name: "중국어"),
        ListItem(name: "중국어")
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

class BottomSheetLayout {

    static func layout(layoutKind: BottomSheetController.Style) -> UICollectionViewCompositionalLayout {

        if layoutKind == .list, #available(iOS 14.0, *) {

            var config = UICollectionLayoutListConfiguration(appearance: .grouped)
            config.backgroundColor = .systemBackground
            return UICollectionViewCompositionalLayout.list(using: config)

        } else {

            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                let columns = layoutKind.columnCount

//                let itemInset: CGFloat = 5.0
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
//                                                             leading: itemInset,
//                                                             bottom: itemInset,
//                                                             trailing: itemInset)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: columns)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            return layout
        }
    }
}

class BottomSheetListConfiguration {

    enum Appearance {

        case plain
        case insetGrouped
        case sideCheckBox
    }

    private let appearance: Appearance

    var backgroundColor: UIColor?

    init(appearance: Appearance) {
        self.appearance = appearance
    }
}
