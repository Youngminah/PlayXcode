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
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresentation ? .to : .from
        guard let controller = transitionContext.viewController(forKey: key) else { return }
        
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

        // UIKit Built-in curve
//        let animator = UIViewPropertyAnimator(
//            duration: animationDuration,
//            curve: .easeInOut)

        // Cubic Bezier curve
//        let animator = UIViewPropertyAnimator(duration: animationDuration,
//                                              controlPoint1: CGPoint(x: 0.1, y: 0.9),
//                                              controlPoint2: CGPoint(x: 0.8, y: 0.2))

        // Spring curve
//        let animator = UIViewPropertyAnimator(duration: animationDuration,
//                                              dampingRatio: 0.5)
//
//        animator.addAnimations {
//            sheetView.frame = finalFrame
//        }
//
//        animator.addCompletion { position in
//            switch position {
//            case .end:
//                if !self.isPresentation {
//                    controller.view.removeFromSuperview()
//                }
//                transitionContext.completeTransition(true)
//            default: // 나중에 새로운 케이스가 생기면 실행됨
//                fatalError()
//            }
//        }
//
//        animator.startAnimation()

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
                transitionContext.completeTransition(finished)
            })
    }
}
