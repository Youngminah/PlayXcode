//
//  PanModalPresentable+Defaults.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/06.
//

import UIKit

extension CustomPanModalPresentable where Self: UIViewController {

    var topOffset: CGFloat {
        return topLayoutOffset + 21.0
    }

    var shortFormHeight: PanModalHeight {
        return longFormHeight
    }

    var longFormHeight: PanModalHeight {

        guard let scrollView = panScrollable else { return .maxHeight }

        scrollView.layoutIfNeeded()
        return .contentHeight(scrollView.contentSize.height)
    }

    var cornerRadius: CGFloat {
        return 8.0
    }

    var springDamping: CGFloat {
        return 0.8
    }

    var transitionDuration: Double {
        return PanModalAnimator.Constants.defaultTransitionDuration
    }

    var transitionAnimationOptions: UIView.AnimationOptions {
        return [.curveEaseInOut, .allowUserInteraction, .beginFromCurrentState]
    }

    var panModalBackgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.7)
    }

    var scrollIndicatorInsets: UIEdgeInsets {
        let top = shouldRoundTopCorners ? cornerRadius : 0
        return UIEdgeInsets(top: CGFloat(top), left: 0, bottom: bottomLayoutOffset, right: 0)
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    var allowsExtendedPanScrolling: Bool {

        guard let scrollView = panScrollable else { return false }

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
        return isPanModalPresented
    }

    func shouldRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return true
    }

    func willRespond(to panModalGestureRecognizer: UIPanGestureRecognizer) {

    }

    func shouldTransition(to state: CustomPresentationController.PresentationState) -> Bool {
        return true
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return false
    }

    func willTransition(to state: CustomPresentationController.PresentationState) {

    }

    func panModalWillDismiss() {
        
    }

    func panModalDidDismiss() {

    }
}

extension CustomPanModalPresentable where Self: UIViewController {

    var presentedVC: CustomPresentationController? {
        return presentationController as? CustomPresentationController
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

        let shortFormYPos = topMargin(from: shortFormHeight) + topOffset
        return max(shortFormYPos, longFormYPos)
    }

    var longFormYPos: CGFloat {
        return max(topMargin(from: longFormHeight), topMargin(from: .maxHeight)) + topOffset
    }

    var bottomYPos: CGFloat {
        guard let container = presentedVC?.containerView else { return view.bounds.height }
        return container.bounds.size.height - topOffset
    }

    func topMargin(from: PanModalHeight) -> CGFloat {
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

extension CustomPanModalPresentable where Self: UIViewController {

    typealias AnimationBlockType = () -> Void
    typealias AnimationCompletionType = (Bool) -> Void
    typealias LayoutType = UIViewController & CustomPanModalPresentable

    func panModalTransition(to state: CustomPresentationController.PresentationState) {
        presentedVC?.transition(to: state)
    }

    func panModalSetNeedsLayoutUpdate() {
        presentedVC?.setNeedsLayoutUpdate()
    }

    func panModalPerformUpdates(_ updates: () -> Void) {
        presentedVC?.performUpdates(updates)
    }

    func panModalAnimate(_ animationBlock: @escaping AnimationBlockType, _ completion: AnimationCompletionType? = nil) {
        PanModalAnimator.animate(animationBlock, config: self, completion)
    }
}


protocol CustomPanModalPresenter: AnyObject {

    var isPanModalPresented: Bool { get }

//    func presentPanModal(_ viewControllerToPresent: CustomPanModalPresentable.LayoutType,
//                         sourceView: UIView?,
//                         sourceRect: CGRect,
//                         completion: (() -> Void)?)

}

extension UIViewController: CustomPanModalPresenter {

    public var isPanModalPresented: Bool {
        return (transitioningDelegate as? CustomPresentationManager) != nil
    }

//    public func presentPanModal(_ viewControllerToPresent: CustomPanModalPresentable.LayoutType,
//                                sourceView: UIView? = nil,
//                                sourceRect: CGRect = .zero,
//                                completion: (() -> Void)? = nil) {
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            viewControllerToPresent.modalPresentationStyle = .popover
//            viewControllerToPresent.popoverPresentationController?.sourceRect = sourceRect
//            viewControllerToPresent.popoverPresentationController?.sourceView = sourceView ?? view
//            viewControllerToPresent.popoverPresentationController?.delegate = Cu.default
//        } else {
//            viewControllerToPresent.modalPresentationStyle = .custom
//            viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
//            viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default
//        }
//
//        present(viewControllerToPresent, animated: true, completion: completion)
//    }

}
