//
//  CurrentViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

class CurrentViewController: UIViewController {

    var items = [
        SelectionItem(name: "딸기🍓"),
        SelectionItem(name: "오렌지🍊"),
        SelectionItem(name: "사과🍎"),
        SelectionItem(name: "레몬🍋"),
        SelectionItem(name: "꽃🌼"),
        SelectionItem(name: "달🌙"),
        SelectionItem(name: "물고기🐠"),
        SelectionItem(name: "개구리🐸"),
        SelectionItem(name: "긴글입니다긴글입니다긴글입니다긴글입니다긴글입니다긴글입니다🦄"),
        SelectionItem(name: "파란나비🦋"),
        SelectionItem(name: "병아리🐥"),
        SelectionItem(name: "페가수스🦄"),
        SelectionItem(name: "새우🍤"),
        SelectionItem(name: "새싹🌱")
    ]

    var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func customButtonTap(_ sender: Any) {
        let vc: SheetPresentable.LayoutType = SheetViewController()
        self.presentSheetModal(vc)
    }
    
    @IBAction func maxButtonTap(_ sender: Any) {
        let vc = SheetViewController<TitleSelectionCell>()
        vc.setItems(items: items)
        vc.selectionItemsHandler = { data in

        }
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
        let bottomSheet = BottomSheetController(preferredStyle: .list(items: items))
        //bottomSheet.allowsMultipleCollection = true
        bottomSheet.addHeaderSubview(SubtitleLabel(text: """
        이곳은 설정하기
        페이지 입니다
        낄낄
        """))
        bottomSheet.addHeaderSubview(TitleLabel(text: "설정하기"))

        let cancelAction = BottomSheetAction(title: "취소", style: .cancel)
        let saveAction = BottomSheetAction(title: "확인", style: .default) { items in
            print(items)
        }

        bottomSheet.addBottomSheetAction(cancelAction)
        bottomSheet.addBottomSheetAction(saveAction)
        self.presentSheetModal(bottomSheet)
//        self.present(bottomSheet, animated: true, completion: nil)
    }
    
    @IBAction func minButtonTap(_ sender: Any) {
        guard let vc : SheetPresentable.LayoutType = self.storyboard?.instantiateViewController(withIdentifier: "Ex2ViewController") as? Ex2ViewController else {
            return
        }
        self.presentSheetModal(vc)
    }
}
