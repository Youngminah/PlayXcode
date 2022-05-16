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
        let vc: SheetPresentable.LayoutType = SheetViewController()
        self.presentSheetModal(vc)
    }
    
    @IBAction func maxButtonTap(_ sender: Any) {
        let vc: SheetPresentable.LayoutType = SheetViewController()
        self.presentSheetModal(vc)
    }
    @IBAction func highButtonTap(_ sender: Any) {
        guard let vc : SheetPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "NextViewController") as? NextViewController else {
            return
        }
        self.presentSheetModal(vc)
    }
    
    @IBAction func mediumButtonTap(_ sender: Any) {
        guard let vc : SheetPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "ExViewController") as? ExViewController else {
            return
        }
        self.presentSheetModal(vc)
    }
    
    @IBAction func lowButtonTap(_ sender: Any) {
        guard let vc : SheetPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "Ex2ViewController") as? Ex2ViewController else {
            return
        }
        self.presentSheetModal(vc)
    }
    
    @IBAction func minButtonTap(_ sender: Any) {
        let vc: SheetPresentable.LayoutType = SheetViewController()
        self.presentSheetModal(vc)
    }
}
