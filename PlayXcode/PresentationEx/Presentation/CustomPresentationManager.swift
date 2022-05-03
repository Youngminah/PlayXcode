//
//  CustomPresentationManager.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/29.
//

import UIKit

final class CustomPresentationManager: NSObject {
    // MARK: - Properties
    var type: PresentationType = .low
    var disableCompactHeight = false
    
    private var fractionalHeight: CGFloat = 0.9 / 1.0
    
    func setFractionalContainerViewHeight(height : CGFloat) {
        type = .none(fractionalHeight)
        fractionalHeight = height
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension CustomPresentationManager: UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {
        let presentationController = CustomPresentationController(
            presentedViewController: presented,
            presenting: presenting,
            type: type,
            fractionalHeight: fractionalHeight
        )
        presentationController.delegate = self
        return presentationController
    }
    
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: true)
    }
    
    func animationController(
        forDismissed dismissed: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentationAnimator(isPresentation: false)
    }
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension CustomPresentationManager: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
            return .overFullScreen
        } else {
            return .none
        }
    }

    func presentationController(
        _ controller: UIPresentationController,
        viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle
    ) -> UIViewController? {
        guard case(.overFullScreen) = style else { return nil }
        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "RotateViewController")
    }
}
