//
//  BottomSheetCollectionViewStyle.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/07/05.
//

import Foundation

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

    var items: [Any] {
        switch self {
        case .list(let items, _), .grid2(let items, _):
            return items
        }
    }
}
