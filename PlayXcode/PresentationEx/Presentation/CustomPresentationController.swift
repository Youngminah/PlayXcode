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
    
    private lazy var defaultHeight: CGFloat = presentedView.frame.height
    private lazy var newY = presentedView.frame.origin.y
    private let dismissibleHeight: CGFloat = 100
    private let minimumContainerY: CGFloat = 64
    private lazy var currentContainerHeight = presentedView.frame.height
    
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
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView
            else { return }
        guard let dimmingView = dimmingView else { return }
        containerView.addSubview(dimmingView)
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        dimmingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        dimmingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        dimmingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        containerView.addSubview(presentedView)
        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(panScroll(recognizer:)))
        panRecognizer.delaysTouchesBegan = false
        panRecognizer.delaysTouchesEnded = false
        presentedView.addGestureRecognizer(panRecognizer)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
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
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: parentSize.height*(0.9/1.0))
    }
    
    private func setupView() {
        dimmingView = DimmingView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.didTap = { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true)
        }
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
        
        guard let piece = recognizer.view else {
            return
        }
        let translation = recognizer.translation(in: piece)
        newY = piece.frame.origin.y + translation.y
        let isDraggingDown = translation.y > 0
        
        switch recognizer.state {
        case .began, .changed:
            if minimumContainerY < newY {
                piece.center = CGPoint(x: piece.center.x, y: piece.center.y + translation.y)
                piece.layoutIfNeeded()
                //recognizer.setTranslation(.zero, in: piece)
            }
        
        case .ended:
            let visibleHeight = UIScreen.main.bounds.height - newY
            
            if visibleHeight < 100 {
                self.animateDismissView()
            }
            else if isDraggingDown {
                animateContainerY(.min)
            }
            else if !isDraggingDown {
                animateContainerY(.max)
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
