//
//  CurrentViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

class CurrentViewController: UIViewController {

    var items = [
        SelectionItem(name: "한국어"),
        SelectionItem(name: "중국어"),
        SelectionItem(name: "일본어"),
        SelectionItem(name: "태국어"),
        SelectionItem(name: "영어"),
        SelectionItem(name: "스페인어"),
        SelectionItem(name: "포루투칼어")
    ]

    lazy var customTransitioningDelegate = CustomPresentationManager()
    var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func customButtonTap(_ sender: Any) {
        let vc: SheetPresentable.LayoutType = SheetViewController()
//        vc.items = [
//            한국어
//            일어
//            중국
//        ]
//
//        vc.items = [
//            3학년
//            4학년
//            5학년
//        ]

//        vc.cellType = UICollectionViewCell.self
//        vc.cellType = WhiteCollectionViewCell.self
        self.presentSheetModal(vc)
    }
    
    @IBAction func maxButtonTap(_ sender: Any) {
        let vc = SheetViewController<LanguageCell>()
        vc.setItems(items: items)
        
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


//class SheetTest<T>: UIViewController where T: SheetCell {
//
//    var cell: T!
//
//    func abc() {
//        
//    }
//}
//
//protocol SheetCell {
//    func configure()
//}
