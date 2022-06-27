//
//  SheetPresentationAnimator.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

struct SheetPresentationAnimator {

    struct Constants {
        static let defaultTransitionDuration: TimeInterval = 0.5
    }

    static func animate(_ animations: @escaping () -> Void,
                        config: SheetPresentable?,
                        _ completion: @escaping ((UIViewAnimatingPosition) -> Void)) {

        let transitionDuration = config?.transitionDuration ?? Constants.defaultTransitionDuration
        let springDamping = config?.springDamping ?? 1.0

        // UIKit Built-in curve
//        let animator = UIViewPropertyAnimator(
//            duration: animationDuration,
//            curve: .easeInOut)

        // Cubic Bezier curve
//        let animator = UIViewPropertyAnimator(duration: animationDuration,
//                                              controlPoint1: CGPoint(x: 0.1, y: 0.9),
//                                              controlPoint2: CGPoint(x: 0.8, y: 0.2))

        // Spring curve
        let animator = UIViewPropertyAnimator(duration: transitionDuration,
                                              dampingRatio: springDamping)

        animator.addAnimations (animations)
        animator.addCompletion (completion)

        animator.startAnimation()
    }
}
