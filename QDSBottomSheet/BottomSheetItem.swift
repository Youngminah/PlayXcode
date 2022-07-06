//
//  BottomSheetItem.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/07/05.
//

import Foundation

public protocol BottomSheetItem: Identifiable {

    associatedtype T

    var id: String { get set }
}

public struct ListItem: BottomSheetItem {

    public typealias T = String

    public var id = UUID().uuidString

    public let name: T

    public init(name: T) {
        self.name = name
    }
}
