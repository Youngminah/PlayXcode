//
//  CustomPanModalPresenter.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/10.
//

import UIKit

protocol CustomPanModalPresenter: AnyObject {

    var isPanModalPresented: Bool { get }

    func presentPanModal(_ viewControllerToPresent: CustomPanModalPresentable.LayoutType,
                         sourceView: UIView?,
                         sourceRect: CGRect,
                         completion: (() -> Void)?)

}

extension UIViewController: CustomPanModalPresenter {

    var isPanModalPresented: Bool {
        return (transitioningDelegate as? CustomPresentationManager) != nil
    }

    func presentPanModal(_ viewControllerToPresent: CustomPanModalPresentable.LayoutType,
                                sourceView: UIView? = nil,
                                sourceRect: CGRect = .zero,
                                completion: (() -> Void)? = nil) {

        if UIDevice.current.userInterfaceIdiom == .pad {
            viewControllerToPresent.modalPresentationStyle = .formSheet
            //viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default
        } else {
            viewControllerToPresent.modalPresentationStyle = .custom
            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
            viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default
        }
        
        present(viewControllerToPresent, animated: true, completion: completion)
    }

}
