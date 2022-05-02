//
//  CustomPresentationController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

enum PresentationType {
    case none
    case max
    case high
    case medium
    case low
    case min
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
    private let dismissibleHeight: CGFloat = 100
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
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
       return PanContainerView(presentedView: presentedViewController.view, frame: frame)
   }()
    
    public override var presentedView: UIView {
        return panContainerView
    }
    
    private var frameOfPresentedViewOriginY: CGFloat {
        return (1.0 - self.fractionalHeight)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController,
                          withParentContainerSize: containerView!.bounds.size)
        switch type {
        case .none:
            frame.origin.y = containerView!.frame.height*(frameOfPresentedViewOriginY)
        case .max:
            frame.origin.y = containerView!.frame.height*(0.1/1.0)
        case .high:
            frame.origin.y = containerView!.frame.height*(0.25/1.0)
        case .medium:
            frame.origin.y = containerView!.frame.height*(0.5/1.0)
        case .low:
            frame.origin.y = containerView!.frame.height*(0.75/1.0)
        case .min:
            frame.origin.y = containerView!.frame.height*(0.85/1.0)
        }
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[dimmingView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["dimmingView": dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
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
    
    override func containerViewWillLayoutSubviews() {
        guard let containerView = containerView
            else { return }
        containerView.addSubview(presentedView)
        presentedView.frame = frameOfPresentedViewInContainerView
        containerView.layer.cornerRadius = 20
    }
    
    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        switch type {
        case .none:
            return CGSize(width: parentSize.width, height: parentSize.height*(fractionalHeight))
        case .max:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.9/1.0))
        case .high:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.75/1.0))
        case .medium:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.5/1.0))
        case .low:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.25/1.0))
        case .min:
            return CGSize(width: parentSize.width, height: parentSize.height*(0.15/1.0))
        }
    }
    
    private func setupView() {
        dimmingView = DimmingView()
        dimmingView.didTap = { [weak self] _ in
            self?.presentedViewController.dismiss(animated: true)
        }

        let panRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(panScroll(recognizer:)))
        panRecognizer.delaysTouchesBegan = false
        panRecognizer.delaysTouchesEnded = false
        presentedView.addGestureRecognizer(panRecognizer)
    }

    
    @objc func panScroll(recognizer: UIPanGestureRecognizer) {
//        guard recognizer.state == .began || recognizer.state == .changed,
//              let piece = recognizer.view, let superview = piece.superview  else {
//            return
//        }
//        let translation = recognizer.translation(in: superview)
//
//        superview.frame.origin.y = superview.frame.origin.y + translation.y
//        superview.frame.size.height = superview.frame.size.height - translation.y
        //superview.layoutIfNeeded()
        //recognizer.setTranslation(.zero, in: superview)
        
        guard let piece = recognizer.view, let superview = piece.superview  else {
            return
        }
        
        let translation = recognizer.translation(in: superview)
        // Drag to top will be minus value and vice versa
        print("Pan gesture y offset: \(translation.y)")

        // Get drag direction
        let isDraggingDown = translation.y > 0
        print("Dragging direction: \(isDraggingDown ? "going down" : "going up")")

        // New height is based on value of dragging plus current container height

        let newHeight = currentContainerHeight - translation.y

        // Handle based on gesture state
        switch recognizer.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                //superview.frame.origin.y = superview.frame.origin.y + translation.y
                print("newHeight", newHeight)
                superview.panContainerView?.frame.size.height = newHeight
                //superview.panContainerView?.layoutIfNeeded()
                
            }
            print("changed")
            
        case .ended:
            if newHeight < 100 {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                // Condition 2: If new height is below default, animate back to default
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                // Condition 3: If new height is below max and going down, set to default height
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                // Condition 4: If new height is below max and going up, set to max height at top
                animateContainerHeight(maximumContainerHeight)
            }
            print("ended")
        default:
            break
        }
    }

    func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            self.presentedView.frame.size.height = height
            self.presentedView.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    
    func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.presentedView.frame.size.height = self.defaultHeight
            self.presentedView.layoutIfNeeded()
        }
        self.presentedViewController.dismiss(animated: false)
    }
}
