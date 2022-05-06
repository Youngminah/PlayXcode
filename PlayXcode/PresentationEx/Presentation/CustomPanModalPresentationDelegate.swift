//
//  CustomPanModalPresentationDelegate.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/06.
//

import UIKit

final class PanModalPresentationDelegate: NSObject {

    var type: PresentationType = .low
    private var fractionalHeight: CGFloat = 0.9 / 1.0
    
    static var `default`: PanModalPresentationDelegate = {
        return PanModalPresentationDelegate()
    }()

}

extension PanModalPresentationDelegate: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: true)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: false)
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = CustomPresentationController(presentedViewController: presented, presenting: presenting, type: type, fractionalHeight: fractionalHeight)
        presentationController.delegate = self
        return presentationController
    }
}

extension PanModalPresentationDelegate: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
