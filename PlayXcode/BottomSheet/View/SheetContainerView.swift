//
//  SheetContainerView.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

final class SheetContainerView: UIView {

    init(presentedView: UIView, frame: CGRect) {
        super.init(frame: frame)
        layer.masksToBounds = true
        addSubview(presentedView)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {

    var sheetContainerView: SheetContainerView? {
        return subviews.first(where: { view -> Bool in
            view is SheetContainerView
        }) as? SheetContainerView
    }
}
