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
        return (transitioningDelegate as? CustomPresentationManager) != nil
    }

    func presentSheetModal(_ viewControllerToPresent: SheetPresentable.LayoutType,
                                sourceView: UIView? = nil,
                                sourceRect: CGRect = .zero,
                                completion: (() -> Void)? = nil) {

        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerToPresent.modalPresentationStyle = .formSheet
            //viewControllerToPresent.transitioningDelegate = SheetPresentationDelegate.default
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            viewControllerToPresent.transitioningDelegate = SheetPresentationDelegate.default
        }
        
        present(viewControllerToPresent, animated: true, completion: completion)
    }

}
