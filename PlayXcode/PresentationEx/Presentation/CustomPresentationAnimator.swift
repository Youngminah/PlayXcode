//
//  CustomPresentationAnimator.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/29.
//

import UIKit

final class CustomPresentationAnimator: NSObject {
    
    // MARK: - Properties
    let isPresentation: Bool
    
    // MARK: - Initializers
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension CustomPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        //controller.beginAppearanceTransition(true, animated: true)
        
        let panView: UIView = transitionContext.containerView.panContainerView ?? controller.view
        
        let presentable = transitionContext.viewController(forKey: .to) as? CustomPanModalPresentable.LayoutType
        let yPos: CGFloat = presentable?.shortFormYPos ?? 0.0
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.y = panView.frame.size.height
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        var finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        
        if isPresentation {
            panView.frame = initialFrame
            finalFrame.origin.y = yPos
        }
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 0,
            options: [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState],
            animations: {
                panView.frame = finalFrame
            }, completion: { finished in
                if !self.isPresentation {
                    controller.view.removeFromSuperview()
                }
                //controller.endAppearanceTransition()
                transitionContext.completeTransition(finished)
            })
    }
}
