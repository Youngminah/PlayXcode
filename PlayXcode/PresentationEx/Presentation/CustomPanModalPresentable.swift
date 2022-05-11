//
//  CustomPanModalPresentable.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

protocol CustomPanModalPresentable: AnyObject {

    var panScrollable: UIScrollView? { get }

    // view의 safearea top inset + 모달 컨테이너뷰의 top offset
    var topOffset: CGFloat { get }

    var isShortFormEnabled: Bool { get }
    
    var shortFormHeight: PanModalHeight { get }
    
    var longFormHeight: PanModalHeight { get }

    //var cornerRadius: CGFloat { get }

    var springDamping: CGFloat { get }

    var transitionDuration: Double { get }

    var transitionAnimationOptions: UIView.AnimationOptions { get }

    var panModalBackgroundColor: UIColor { get }

    var scrollIndicatorInsets: UIEdgeInsets { get }

    var anchorModalToLongForm: Bool { get }

    var allowsExtendedPanScrolling: Bool { get }

    var allowsDragToDismiss: Bool { get }

    var allowsTapToDismiss: Bool { get }

    // False이면 presentingViewController에서 터치 불가능.
    var isUserInteractionEnabled: Bool { get }

    var shouldRoundTopCorners: Bool { get }

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
