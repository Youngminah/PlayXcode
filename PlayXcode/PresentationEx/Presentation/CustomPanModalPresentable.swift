//
//  CustomPanModalPresentable.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

protocol PanModalPresentable: AnyObject {

    
    var panScrollable: UIScrollView? { get }

    var topOffset: CGFloat { get }
    
    var shortFormHeight: PanModalHeight { get }
    
    var longFormHeight: PanModalHeight { get }

    var cornerRadius: CGFloat { get }

    var springDamping: CGFloat { get }

    var transitionDuration: Double { get }

    var transitionAnimationOptions: UIView.AnimationOptions { get }

    var panModalBackgroundColor: UIColor { get }

    var dragIndicatorBackgroundColor: UIColor { get }

    var scrollIndicatorInsets: UIEdgeInsets { get }

    var anchorModalToLongForm: Bool { get }

    var allowsExtendedPanScrolling: Bool { get }

    var allowsDragToDismiss: Bool { get }

    var allowsTapToDismiss: Bool { get }

    var isUserInteractionEnabled: Bool { get }

    var isHapticFeedbackEnabled: Bool { get }

    var shouldRoundTopCorners: Bool { get }

    var showDragIndicator: Bool { get }

    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer)

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    func shouldTransition(to state: CustomPresentationController.PresentationState) -> Bool

    func willTransition(to state: CustomPresentationController.PresentationState)

    func panModalWillDismiss()

    func panModalDidDismiss()
}

enum PanModalHeight: Equatable {

    case maxHeight
    case maxHeightWithTopInset(CGFloat)
    case contentHeight(CGFloat)
    case contentHeightIgnoringSafeArea(CGFloat)
    case intrinsicHeight
}
