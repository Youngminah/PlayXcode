//
//  SheetPresentationAnimator.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/29.
//

import UIKit

final class SheetPresentationAnimatedTransitioning: NSObject {
    
    // MARK: - Properties
    let isPresentation: Bool
    
    // MARK: - Initializers
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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        //controller.beginAppearanceTransition(true, animated: true)
        
        let sheetView: UIView = transitionContext.containerView.sheetContainerView ?? controller.view
        
        let presentable = transitionContext.viewController(forKey: .to) as? SheetPresentable.LayoutType
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = sheetView.frame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        var finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        if isPresentation {
            sheetView.frame = initialFrame
            finalFrame.origin.y = yPos
        }

//        let animator = UIViewPropertyAnimator()
//
//        animator.addAnimations {
//
//        }
//
//        animator.addAnimations {
//
//        }
//
//        animator.fractionComplete = 0.3
//
//        animator.addCompletion { position in
//            
//        }

        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
            animations: {
                sheetView.frame = finalFrame
            }, completion: { finished in
                if !self.isPresentation {
                    controller.view.removeFromSuperview()
                }
                //controller.endAppearanceTransition()
                transitionContext.completeTransition(finished)
            })
    }
}
