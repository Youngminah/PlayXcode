//
//  SheetPresentationAnimator.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/29.
//

import UIKit

final class SheetPresentationAnimatedTransitioning: NSObject {

    private let isPresentation: Bool

    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SheetPresentationAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 1.0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let sheetView: UIView = transitionContext.containerView.sheetContainerView ?? controller.view

        let presentable = transitionContext.viewController(forKey: key) as? SheetPresentable.LayoutType
        fromVC.beginAppearanceTransition(false, animated: false)
        //print(controller.isViewLoaded)
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0
        
        var presentedFrame = transitionContext.finalFrame(for: controller)
        presentedFrame.origin.y = yPos

        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = transitionContext.containerView.frame.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        if isPresentation {
            sheetView.frame = initialFrame
        }

        SheetPresentationAnimator.animate({
            sheetView.frame = finalFrame
        }, config: presentable) { [weak self] position in
            guard let self = self else { return }
            switch position {
            case .end:
                if !self.isPresentation {
                    controller.view.removeFromSuperview()
                }
                transitionContext.completeTransition(true)
            default:
                fatalError()
            }
        }
    }
}
