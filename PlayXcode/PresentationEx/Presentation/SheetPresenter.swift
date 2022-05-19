//
//  SheetPresenter.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/10.
//

import UIKit

protocol SheetPresenter: AnyObject {

    var isSheetPresented: Bool { get }

    func presentSheetModal(_ viewControllerToPresent: SheetPresentable.LayoutType,
                         sourceView: UIView?,
                         sourceRect: CGRect,
                         completion: (() -> Void)?)

}

extension UIViewController: SheetPresenter {

    var isSheetPresented: Bool {
        return (transitioningDelegate as? SheetTransitioningDelegate) != nil
    }

    func presentSheetModal(_ viewControllerToPresent: SheetPresentable.LayoutType,
                                sourceView: UIView? = nil,
                                sourceRect: CGRect = .zero,
                                completion: (() -> Void)? = nil) {

        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerToPresent.modalPresentationStyle = .formSheet
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            viewControllerToPresent.transitioningDelegate = SheetTransitioningDelegate.default
        }
        present(viewControllerToPresent, animated: true, completion: completion)
    }

}
