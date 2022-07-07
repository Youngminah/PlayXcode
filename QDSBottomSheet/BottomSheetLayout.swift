//
//  BottomSheetLayout.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/06/07.
//

import UIKit

open class BottomSheetLayout {

    static func layout(layoutKind: BottomSheetStyle) -> UICollectionViewCompositionalLayout {

        if layoutKind.columnCount == 1, #available(iOS 14.0, *) {

            var config = UICollectionLayoutListConfiguration(appearance: layoutKind.collectionLayoutListAppearance)
            config.backgroundColor = .systemBackground
            config.showsSeparators = layoutKind.showCollectionLayoutSeperators
            return UICollectionViewCompositionalLayout.list(using: config)

        } else {

            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                let columns = layoutKind.columnCount

                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))

                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitem: item,
                                                               count: columns)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = layoutKind.sectionInsets
                return section
            }
    
            return layout
        }
    }
}
