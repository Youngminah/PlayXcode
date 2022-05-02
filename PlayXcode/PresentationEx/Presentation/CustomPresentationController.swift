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
    
    private var dimmingView: UIView!
    
    private var type: PresentationType
    private var fractionalHeight: CGFloat
    
    init(presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?,
         type: PresentationType,
         fractionalHeight: CGFloat
    ) {
        self.type = type
        self.fractionalHeight = fractionalHeight
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
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
        presentedView?.frame = frameOfPresentedViewInContainerView
        presentedView?.layer.cornerRadius = 20
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
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(recognizer)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
}
