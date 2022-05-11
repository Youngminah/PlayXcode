//
//  CurrentViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

class CurrentViewController: UIViewController {
    
    lazy var customTransitioningDelegate = CustomPresentationManager()
    
    var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func customButtonTap(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") else {
            return
        }
        customTransitioningDelegate.setFractionalContainerViewHeight(height: 0.3/1.0)
        customTransitioningDelegate.disableCompactHeight = false
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    
    @IBAction func maxButtonTap(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") else {
            return
        }
        customTransitioningDelegate.type = .max
        customTransitioningDelegate.disableCompactHeight = false
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
    @IBAction func highButtonTap(_ sender: Any) {
        guard let vc : CustomPanModalPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as? NextViewController else {
            return
        }
        self.presentPanModal(vc)
    }
    
    @IBAction func mediumButtonTap(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ExViewController") else {
            return
        }
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = PanModalPresentationDelegate.default
        self.present(vc, animated: true)
    }
    
    @IBAction func lowButtonTap(_ sender: Any) {
        guard let vc : CustomPanModalPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "Ex2ViewController") as? Ex2ViewController else {
            return
        }
        self.presentPanModal(vc)
    }
    
    @IBAction func minButtonTap(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Ex2ViewController") else {
            return
        }
        customTransitioningDelegate.type = .min
        customTransitioningDelegate.disableCompactHeight = false
        vc.transitioningDelegate = customTransitioningDelegate
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
    }
}
