//
//  BottomSheetLayout.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/06/07.
//

import UIKit

open class SheetLayout {

    static func layout(layoutKind: BottomSheetController.Style) -> UICollectionViewCompositionalLayout {

        if #available(iOS 14.0, *) {

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

    static func dataSource(style: BottomSheetController.Style) {

//        switch style {
//        case .list(items: let items, layoutStyle: let layoutStyle):
//
//        case .grid2(items: let items, layoutStyle: let layoutStyle):
//            <#code#>
//        }
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
