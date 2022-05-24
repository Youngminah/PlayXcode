//
//  SheetPresentable.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/02.
//

import UIKit

protocol SheetPresentable: AnyObject {

    var sheetScrollView: UIScrollView? { get }

    var topOffset: CGFloat { get } // view의 safearea top inset + 모달 컨테이너뷰의 top offset
    
    var shortFormHeight: SheetHeight { get }
    
    var longFormHeight: SheetHeight { get }

    var cornerRadius: CGFloat { get }

    var springDamping: CGFloat { get }

    var transitionDuration: Double { get }

    var transitionAnimationOptions: UIView.AnimationOptions { get }

    var sheetModalBackgroundColor: UIColor { get }

    var scrollIndicatorInsets: UIEdgeInsets { get }

    var anchorModalToLongForm: Bool { get }

    var allowsExtendedSheetScrolling: Bool { get }

    var allowsDragToDismiss: Bool { get }

    var allowsTapToDismiss: Bool { get }

    var isUserInteractionEnabled: Bool { get } // False이면 presentingViewController에서 터치 불가능.

    var shouldRoundTopCorners: Bool { get }

    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer)

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool

    func shouldTransition(to state: SheetPresentationController.PresentationState) -> Bool

    func willTransition(to state: SheetPresentationController.PresentationState)

    func sheetModalWillDismiss()

    func sheetModalDidDismiss()
}

enum SheetHeight: Equatable {

    case maxHeight
    case maxHeightWithTopInset(CGFloat)
    case contentHeight(CGFloat)
    case contentHeightIgnoringSafeArea(CGFloat)
    case intrinsicHeight
}
