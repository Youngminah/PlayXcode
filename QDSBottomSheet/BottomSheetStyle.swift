//
//  BottomSheetCollectionViewStyle.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/07/05.
//

import UIKit

public enum BottomSheetStyle {

    public enum ListAppearance {

        case plain
        case checkBox
    }

    case list(items: [ListItem], appearance: ListAppearance)
    case grid2(items: [ListItem], appearance: ListAppearance)

    var columnCount: Int {
        switch self {
        case .list:
            return 1
        case .grid2:
            return 2
        }
    }

    var sectionInsets: NSDirectionalEdgeInsets {
        switch self {
        case .list(_, let appearance):
            switch appearance {
            case .plain:
                return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            case .checkBox:
                return NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            }
        case .grid2(_, let appearance):
            switch appearance {
            case .plain:
                return NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            case .checkBox:
                return NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            }
        }
    }

    var items: [Any] {
        switch self {
        case .list(let items, _), .grid2(let items, _):
            return items
        }
    }

    @available(iOS 14.0, *)
    var collectionLayoutListAppearance: UICollectionLayoutListConfiguration.Appearance {
        switch self {
        case .list(_, let appearance), .grid2(_, let appearance):
            switch appearance {
            case .plain:
                return .plain
            case .checkBox:
                return .insetGrouped
            }
        }
    }

    @available(iOS 14.0, *)
    var showCollectionLayoutSeperators: Bool {
        switch self {
        case .list(_, let appearance), .grid2(_, let appearance):
            switch appearance {
            case .plain:
                return false
            case .checkBox:
                return true
            }
        }
    }
}
