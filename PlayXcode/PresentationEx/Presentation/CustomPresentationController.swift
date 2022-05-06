//
//  CustomPresentationController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

enum PresentationType {
    case none(CGFloat)
    case max
    case high
    case medium
    case low
    case min
    
    var positionY: CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        switch self {
        case .none(let fractionY):
            return screenHeight*(fractionY)
        case .max:
            return screenHeight*(0.1/1.0)
        case .high:
            return screenHeight*(0.25/1.0)
        case .medium:
            return screenHeight*(0.5/1.0)
        case .low:
            return screenHeight*(0.75/1.0)
        case .min:
            return screenHeight*(0.85/1.0)
        }
    }
}

final class CustomPresentationController: UIPresentationController {
    
    enum PresentationState {
        case shortForm
        case longForm
    }
    
    struct Constants {
        static let indicatorYOffset = CGFloat(8.0)
        static let snapMovementSensitivity = CGFloat(0.7)
        static let dragIndicatorSize = CGSize(width: 36.0, height: 5.0)
    }
    
    private var dimmingView: DimmingView!
    private var type: PresentationType
    private var fractionalHeight: CGFloat
    private var originalPosition: CGPoint?
    
    private var scrollViewYOffset: CGFloat = 0.0
    private let dismissibleHeight: CGFloat = 100
    private let minimumContainerY: CGFloat = 64
    private var shortFormYPosition: CGFloat = 0
    private var longFormYPosition: CGFloat = 0.0
    private var extendsPanScrolling = true
    private var anchorModalToLongForm = true
    private var isPresentedViewAnimating = false
    private var scrollObserver: NSKeyValueObservation?
    
    private lazy var defaultHeight: CGFloat = presentedView.frame.height
    private lazy var currentContainerHeight = presentedView.frame.height
    private lazy var newY = presentedView.frame.origin.y
    
    deinit {
        scrollObserver?.invalidate()
    }
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         type: PresentationType,
         fractionalHeight: CGFloat
    ) {
        self.type = type
        self.fractionalHeight = fractionalHeight
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupView()
    }
    
    private var presentable: CustomPanModalPresentable? {
        return presentedViewController as? CustomPanModalPresentable
    }
    
    private var anchoredYPosition: CGFloat {
        let defaultTopOffset = presentable?.topOffset ?? 0
        return anchorModalToLongForm ? longFormYPosition : defaultTopOffset
    }
    
    private lazy var panContainerView: PanContainerView = {
        let frame = containerView?.frame ?? .zero
        return PanContainerView(presentedView: presentedViewController.view, frame: frameOfPresentedViewInContainerView)
    }()
    
    override var presentedView: UIView {
        return panContainerView
    }
    
    private var frameOfPresentedViewOriginY: CGFloat {
        return (1.0 - self.fractionalHeight)
    }
    
    var isPresentedViewAnchored: Bool {
        if !isPresentedViewAnimating
            && extendsPanScrolling
            && presentedView.frame.minY.rounded() <= anchoredYPosition.rounded() {
            return true
        }
        return false
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero}
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView.bounds.size)
        frame.origin.y = type.positionY
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView.frame = frameOfPresentedViewInContainerView
        presentedView.layer.cornerRadius = 20
        shortFormYPosition = type.positionY
        longFormYPosition = type.positionY
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView
            else { return }
        guard let dimmingView = dimmingView else { return }
        layoutBackgroundView(in: containerView)
        layoutPresentedView(in: containerView)
        
        
        //shortFormYPosition = type.positionY
        longFormYPosition = type.positionY
        adjustPresentedViewFrame()

        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.dimmingView.alpha = 1.0
        })
    }
    
    override public func presentationTransitionDidEnd(_ completed: Bool) {
        if completed { return }
        dimmingView.removeFromSuperview()
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override public func dismissalTransitionDidEnd(_ completed: Bool) {
        if !completed { return }
        presentable?.panModalDidDismiss()
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
//            guard
//                let self = self,
//                let presentable = self.presentable
//                else { return }

            self.adjustPresentedViewFrame()
//            if presentable.shouldRoundTopCorners {
//                self.addRoundedCorners(to: self.presentedView)
//            }
        })
    }
    
    func configureViewLayout() {
        guard let layoutPresentable = presentedViewController as? CustomPanModalPresentable.LayoutType else { return }
        shortFormYPosition = layoutPresentable.shortFormYPos
        longFormYPosition = layoutPresentable.longFormYPos
        anchorModalToLongForm = layoutPresentable.anchorModalToLongForm
        extendsPanScrolling = layoutPresentable.allowsExtendedPanScrolling
        containerView?.isUserInteractionEnabled = layoutPresentable.isUserInteractionEnabled
    }
    
    func adjustPresentedViewFrame() {
        presentedView.isUserInteractionEnabled = true

        guard let frame = containerView?.frame else { return }


        let adjustedSize = CGSize(width: frame.size.width, height: frame.size.height - anchoredYPosition)
    
        let panFrame = panContainerView.frame
        panContainerView.frame.size = frame.size

        if ![shortFormYPosition, longFormYPosition].contains(panFrame.origin.y) {
            let yPosition = panFrame.origin.y - panFrame.height + frame.height
            presentedView.frame.origin.y = max(yPosition, anchoredYPosition)
        }
        
        panContainerView.frame.origin.x = frame.origin.x
        
        presentedViewController.view.frame = CGRect(origin: .zero, size: adjustedSize)
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height)
    }
    
    func layoutBackgroundView(in containerView: UIView) {
        containerView.addSubview(dimmingView)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
    
    func layoutPresentedView(in containerView: UIView) {
        
        containerView.addSubview(presentedView)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(panScroll(recognizer:)))
        panGestureRecognizer.minimumNumberOfTouches = 1
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delaysTouchesBegan = false
        panGestureRecognizer.delaysTouchesEnded = false
        panGestureRecognizer.delegate = self
        containerView.addGestureRecognizer(panGestureRecognizer)

        setNeedsLayoutUpdate()
        //adjustPanContainerBackgroundColor()
    }
    
    private func setupView() {
        dimmingView = DimmingView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.didTap = { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true)
        }
    }
    
    func configureScrollViewInsets() {

        guard
            let scrollView = presentable?.panScrollable,
            !scrollView.isScrolling
            else { return }

        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollIndicatorInsets = presentable?.scrollIndicatorInsets ?? .zero
        //scrollView.contentInset.bottom = presentingViewController.view.safeAreaLayoutGuide.bottomAnchor
        scrollView.contentInsetAdjustmentBehavior = .never
        
    }

    
    @objc func panScroll(recognizer: UIPanGestureRecognizer) {
        
//        guard recognizer.state == .began || recognizer.state == .changed,
//              let piece = recognizer.view else {
//            return
//        }
//        let translation = recognizer.translation(in: piece)
//        piece.center = CGPoint(x: piece.center.x, y: piece.center.y + translation.y)
//        piece.layoutIfNeeded()
//        recognizer.setTranslation(.zero, in: piece)
        
        guard
            shouldRespond(to: recognizer),
            let containerView = containerView
            else {
                recognizer.setTranslation(.zero, in: recognizer.view)
                return
        }
        
        guard let piece = recognizer.view else {
            return
        }
        let translation = recognizer.translation(in: piece)
        newY = piece.frame.origin.y + translation.y
        let isDraggingDown = translation.y > 0
        
        switch recognizer.state {
        case .began, .changed:
            respond(to: recognizer)
            
//            if minimumContainerY < newY {
//                piece.center = CGPoint(x: piece.center.x, y: piece.center.y + translation.y)
//                piece.layoutIfNeeded()
//                //recognizer.setTranslation(.zero, in: piece)
//            }
            if presentedView.frame.origin.y == anchoredYPosition && extendsPanScrolling {
                presentable?.willTransition(to: .longForm)
            }
        
        case .ended:
//            let visibleHeight = UIScreen.main.bounds.height - newY
//
//            if visibleHeight < 100 {
//                self.animateDismissView()
//            }
//            else if isDraggingDown {
//                animateContainerY(.min)
//            }
//            else if !isDraggingDown {
//                animateContainerY(.max)
//            }
            let velocity = recognizer.velocity(in: presentedView)

            if isVelocityWithinSensitivityRange(velocity.y) {

                /**
                 If velocity is within the sensitivity range,
                 transition to a presentation state or dismiss entirely.

                 This allows the user to dismiss directly from long form
                 instead of going to the short form state first.
                 */
                if velocity.y < 0 {
                    transition(to: .longForm)

                } else if (nearest(to: presentedView.frame.minY, inValues: [longFormYPosition, containerView.bounds.height]) == longFormYPosition
                    && presentedView.frame.minY < shortFormYPosition) || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }

            } else {

                /**
                 The `containerView.bounds.height` is used to determine
                 how close the presented view is to the bottom of the screen
                 */
                let position = nearest(to: presentedView.frame.minY, inValues: [containerView.bounds.height, shortFormYPosition, longFormYPosition])

                if position == longFormYPosition {
                    transition(to: .longForm)

                } else if position == shortFormYPosition || presentable?.allowsDragToDismiss == false {
                    transition(to: .shortForm)

                } else {
                    presentedViewController.dismiss(animated: true)
                }
            }
        default:
            break
        }
        //recognizer.setTranslation(.zero, in: piece)

//        let translation = recognizer.translation(in: piece)
//        // Drag to top will be minus value and vice versa
//        print("Pan gesture y offset: \(translation.y)")
//
//        // Get drag direction
//        let isDraggingDown = translation.y > 0
//        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")
//
//        // New height is based on value of dragging plus current container height
//
//        let newHeight = piece.frame.origin.y - translation.y
//
//        // Handle based on gesture state
//        switch recognizer.state {
//        case .changed:
//            if newHeight < maximumContainerHeight {
//                piece.center = CGPoint(x: piece.center.x, y: piece.center.y + translation.y)
//                print("newHeight", newHeight)
//                piece.layoutIfNeeded()
//                //print("superview", piece.superview)
//
//
//                recognizer.setTranslation(.zero, in: piece)
//            }
//            print("changed")
//
//        case .ended:
//            if newHeight < 100 {
//                self.animateDismissView()
//            }
//            else if newHeight < defaultHeight {
//                // Condition 2: If new height is below default, animate back to default
//                animateContainerHeight(defaultHeight)
//            }
//            else if newHeight < maximumContainerHeight && isDraggingDown {
//                // Condition 3: If new height is below max and going down, set to default height
//                animateContainerHeight(defaultHeight)
//            }
//            else if newHeight > defaultHeight && !isDraggingDown {
//                // Condition 4: If new height is below max and going up, set to max height at top
//                animateContainerHeight(maximumContainerHeight)
//            }
//            print("ended")
//        default:
//            break
//        }
    }
    
    func shouldRespond(to panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        guard
            presentable?.shouldRespond(to: panGestureRecognizer) == true ||
                !(panGestureRecognizer.state == .began || panGestureRecognizer.state == .cancelled)
            else {
                panGestureRecognizer.isEnabled = false
                panGestureRecognizer.isEnabled = true
                return false
        }
        return !shouldFail(panGestureRecognizer: panGestureRecognizer)
    }

    /**
     Communicate intentions to presentable and adjust subviews in containerView
     */
    func respond(to panGestureRecognizer: UIPanGestureRecognizer) {
        presentable?.willRespond(to: panGestureRecognizer)

        var yDisplacement = panGestureRecognizer.translation(in: presentedView).y

        /**
         If the presentedView is not anchored to long form, reduce the rate of movement
         above the threshold
         */
        if presentedView.frame.origin.y < longFormYPosition {
            yDisplacement /= 2.0
        }
        adjust(toYPosition: presentedView.frame.origin.y + yDisplacement)

        panGestureRecognizer.setTranslation(.zero, in: presentedView)
    }

    /**
     Determines if we should fail the gesture recognizer based on certain conditions

     We fail the presented view's pan gesture recognizer if we are actively scrolling on the scroll view.
     This allows the user to drag whole view controller from outside scrollView touch area.

     Unfortunately, cancelling a gestureRecognizer means that we lose the effect of transition scrolling
     from one view to another in the same pan gesture so don't cancel
     */
    func shouldFail(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {

        /**
         Allow api consumers to override the internal conditions &
         decide if the pan gesture recognizer should be prioritized.

         ⚠️ This is the only time we should be cancelling the panScrollable recognizer,
         for the purpose of ensuring we're no longer tracking the scrollView
         */
        guard !shouldPrioritize(panGestureRecognizer: panGestureRecognizer) else {
            presentable?.panScrollable?.panGestureRecognizer.isEnabled = false
            presentable?.panScrollable?.panGestureRecognizer.isEnabled = true
            return false
        }

        guard
            isPresentedViewAnchored,
            let scrollView = presentable?.panScrollable,
            scrollView.contentOffset.y > 0
            else {
                return false
        }

        let loc = panGestureRecognizer.location(in: presentedView)
        return (scrollView.frame.contains(loc) || scrollView.isScrolling)
    }

    /**
     Determine if the presented view's panGestureRecognizer should be prioritized over
     embedded scrollView's panGestureRecognizer.
     */
    func shouldPrioritize(panGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        return panGestureRecognizer.state == .began &&
            presentable?.shouldPrioritize(panModalGestureRecognizer: panGestureRecognizer) == true
    }
    
    func isVelocityWithinSensitivityRange(_ velocity: CGFloat) -> Bool {
        return (abs(velocity) - (1000 * (1 - Constants.snapMovementSensitivity))) > 0
    }

    func snap(toYPosition yPos: CGFloat) {
        PanModalAnimator.animate({ [weak self] in
            self?.adjust(toYPosition: yPos)
            self?.isPresentedViewAnimating = true
        }, config: presentable) { [weak self] didComplete in
            self?.isPresentedViewAnimating = !didComplete
        }
    }

    
    func adjust(toYPosition yPos: CGFloat) {
        presentedView.frame.origin.y = max(yPos, anchoredYPosition)
        
        guard presentedView.frame.origin.y > shortFormYPosition else {
            dimmingView.alpha = 1.0
            return
        }
        dimmingView.alpha = 0.7
    }
    
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
            else { return number }
        return nearestVal
    }

    func animateContainerY(_ type: PresentationType) {
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.presentedView.frame.origin.y = type.positionY
                self.presentedView.layoutIfNeeded()
            })
        newY = type.positionY
    }
    
    
    func animateDismissView() {
        UIView.animate(withDuration: 3) {
            self.presentedView.frame.origin.y = UIScreen.main.bounds.height
            self.presentedView.layoutIfNeeded()
        }
        self.presentedViewController.dismiss(animated: false)
    }
}

extension CustomPresentationController {

    func transition(to state: PresentationState) {

        guard presentable?.shouldTransition(to: state) == true
            else { return }

        presentable?.willTransition(to: state)

        switch state {
        case .shortForm:
            snap(toYPosition: shortFormYPosition)
        case .longForm:
            snap(toYPosition: longFormYPosition)
        }
    }

    func performUpdates(_ updates: () -> Void) {

        guard let scrollView = presentable?.panScrollable
            else { return }

        // Pause scroll observer
        scrollObserver?.invalidate()
        scrollObserver = nil

        // Perform updates
        updates()

        // Resume scroll observer
        trackScrolling(scrollView)
        observe(scrollView: scrollView)
    }

    func setNeedsLayoutUpdate() {
        configureViewLayout()
        adjustPresentedViewFrame()
        observe(scrollView: presentable?.panScrollable)
        configureScrollViewInsets()
    }

}

extension CustomPresentationController {

    func observe(scrollView: UIScrollView?) {
        scrollObserver?.invalidate()
        scrollObserver = scrollView?.observe(\.contentOffset, options: .old) { [weak self] scrollView, change in

            guard self?.containerView != nil
                else { return }

            self?.didPanOnScrollView(scrollView, change: change)
        }
    }

    func didPanOnScrollView(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {

        guard
            !presentedViewController.isBeingDismissed,
            !presentedViewController.isBeingPresented
            else { return }

        if !isPresentedViewAnchored && scrollView.contentOffset.y > 0 {

            haltScrolling(scrollView)

        } else if scrollView.isScrolling || isPresentedViewAnimating {

            if isPresentedViewAnchored {
                trackScrolling(scrollView)
            } else {
                haltScrolling(scrollView)
            }

        } else if presentedViewController.view.isKind(of: UIScrollView.self)
            && !isPresentedViewAnimating && scrollView.contentOffset.y <= 0 {

            handleScrollViewTopBounce(scrollView: scrollView, change: change)
        } else {
            trackScrolling(scrollView)
        }
    }

    func haltScrolling(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollViewYOffset), animated: false)
        scrollView.showsVerticalScrollIndicator = false
    }

    func trackScrolling(_ scrollView: UIScrollView) {
        scrollViewYOffset = max(scrollView.contentOffset.y, 0)
        scrollView.showsVerticalScrollIndicator = true
    }
    
    func handleScrollViewTopBounce(scrollView: UIScrollView, change: NSKeyValueObservedChange<CGPoint>) {

        guard let oldYValue = change.oldValue?.y, scrollView.isDecelerating
            else { return }

        let yOffset = scrollView.contentOffset.y
        let presentedSize = containerView?.frame.size ?? .zero

        presentedView.bounds.size = CGSize(width: presentedSize.width, height: presentedSize.height + yOffset)

        if oldYValue > yOffset {
            presentedView.frame.origin.y = longFormYPosition - yOffset
        } else {
            scrollViewYOffset = 0
            snap(toYPosition: longFormYPosition)
        }

        scrollView.showsVerticalScrollIndicator = false
    }
}

extension CustomPresentationController: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return otherGestureRecognizer.view == presentable?.panScrollable
    }
}

private extension UIScrollView {

    var isScrolling: Bool {
        return isDragging && !isDecelerating || isTracking
    }
}
