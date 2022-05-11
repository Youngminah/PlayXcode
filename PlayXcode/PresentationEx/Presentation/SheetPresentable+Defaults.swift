//
//  SheetModalPresentable+Defaults.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/06.
//

import UIKit

extension SheetPresentable where Self: UIViewController {

    var topOffset: CGFloat {
        return topLayoutOffset + 21.0
    }

    var isShortFormEnabled: Bool {
        return true
    }

    var shortFormHeight: SheetHeight {
        return longFormHeight
    }

    var longFormHeight: SheetHeight {

        guard let scrollView = sheetScrollView else { return .maxHeight }

        scrollView.layoutIfNeeded()
        return .contentHeight(scrollView.contentSize.height)
    }

    var cornerRadius: CGFloat {
        return 15.0
    }

    var springDamping: CGFloat {
        return 0.8
    }

    var transitionDuration: Double {
        return SheetPresentationAnimator.Constants.defaultTransitionDuration
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    var sheetModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let top = shouldRoundTopCorners ? cornerRadius : 0
        return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    var allowsExtendedSheetScrolling: Bool {

        guard let scrollView = sheetScrollView else { return false }
        scrollView.layoutIfNeeded()

        return scrollView.contentSize.height > (scrollView.frame.height - bottomLayoutOffset)
    }

    var allowsDragToDismiss: Bool {
        return true
    }

    var allowsTapToDismiss: Bool {
        return true
    }

    var isUserInteractionEnabled: Bool {
        return true
    }

    var shouldRoundTopCorners: Bool {
        return isSheetPresented
    }

    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return true
    }

    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {

    }

    func shouldTransition(to state: SheetPresentationController.PresentationState) -> Bool {
        return true
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {

    }

    func sheetModalWillDismiss() {
        
    }

    func sheetModalDidDismiss() {

    }
}

extension SheetPresentable where Self: UIViewController {

    var presentedVC: SheetPresentationController? {
        return presentationController as? SheetPresentationController
    }
    
    var topLayoutOffset: CGFloat {
        guard let rootVC = rootViewController else { return 0 }
        return rootVC.view.safeAreaInsets.top
    }
    
    var bottomLayoutOffset: CGFloat {
       guard let rootVC = rootViewController else { return 0 }
        return rootVC.view.safeAreaInsets.bottom
    }

    var shortFormYPos: CGFloat {
        guard !UIAccessibility.isVoiceOverRunning else { return longFormYPos }
        let topMarginOffset = isShortFormEnabled ? topMargin(from: shortFormHeight) : topMargin(from: longFormHeight)
        let shortFormYPos = topMarginOffset + topOffset
        return max(shortFormYPos, longFormYPos)
    }

    var longFormYPos: CGFloat {

        return max(topMargin(from: longFormHeight), topMargin(from: .maxHeight)) + topOffset
    }

    var bottomYPos: CGFloat {
        guard let container = presentedVC?.containerView else { return view.bounds.height }

        return container.bounds.size.height - topOffset
    }

    func topMargin(from: SheetHeight) -> CGFloat {
        switch from {
        case .maxHeight:
            return 0.0
        case .maxHeightWithTopInset(let inset):
            return inset
        case .contentHeight(let height):
            
            return bottomYPos - (height + bottomLayoutOffset)
        case .contentHeightIgnoringSafeArea(let height):
            return bottomYPos - height
        case .intrinsicHeight:
            view.layoutIfNeeded()
            
            let targetSize = CGSize(width: (presentedVC?.containerView?.bounds ?? UIScreen.main.bounds).width,
                                    height: UIView.layoutFittingCompressedSize.height)
            let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
            return bottomYPos - (intrinsicHeight + bottomLayoutOffset)
        }
    }

    private var rootViewController: UIViewController? {

        guard let application = UIApplication.value(forKeyPath: #keyPath(UIApplication.shared)) as? UIApplication
            else { return nil }
        return application.keyWindow?.rootViewController
    }
}

extension SheetPresentable where Self: UIViewController {

    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias LayoutType = UIViewController & SheetPresentable

    func panModalTransition(to state: SheetPresentationController.PresentationState) {
        presentedVC?.transition(to: state)
    }

    func sheetModalSetNeedsLayoutUpdate() {
        presentedVC?.setNeedsLayoutUpdate()
    }

    func panModalPerformUpdates(_ updates: () -> Void) {
        presentedVC?.performUpdates(updates)
    }

    func panModalAnimate(_ animationBlock: @escaping AnimationBlockType, _ completion: AnimationCompletionType? = nil) {
        SheetPresentationAnimator.animate(animationBlock, config: self, completion)
    }
}
