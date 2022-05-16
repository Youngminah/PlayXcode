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
                        _ completion: ((Bool) -> Void)? = nil) {

        let transitionDuration = config?.transitionDuration ?? Constants.defaultTransitionDuration
        let springDamping = config?.springDamping ?? 1.0
        let animationOptions = config?.transitionAnimationOptions ?? []

        UIView.animate(withDuration: transitionDuration,
                       delay: 0,
                       usingSpringWithDamping: springDamping,
                       initialSpringVelocity: 0,
                       options: animationOptions,
                       animations: animations,
                       completion: completion)
    }
}
