//
//  CurrentViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit
import QDSBottomSheet

class CurrentViewController: UIViewController {

    var items = [
        ListItem(name: "딸기🍓"),
        ListItem(name: "오렌지🍊"),
        ListItem(name: "사과🍎"),
        ListItem(name: "레몬🍋"),
        ListItem(name: "꽃🌼"),
        ListItem(name: "달🌙"),
        ListItem(name: "물고기🐠"),
        ListItem(name: "개구리🐸"),
        ListItem(name: "긴글입니다긴글입니다긴글입니다긴글입니다긴글입니다긴글입니다🦄"),
        ListItem(name: "파란나비🦋"),
        ListItem(name: "병아리🐥"),
        ListItem(name: "페가수스🦄"),
        ListItem(name: "새우🍤"),
        ListItem(name: "새싹🌱")
    ]

    var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func customButtonTap(_ sender: Any) {
        //let vc: SheetPresentable.LayoutType = SheetViewController()
        //self.presentSheetModal(vc)
    }
    
    @IBAction func maxButtonTap(_ sender: Any) {
//        let vc = SheetViewController<TitleSelectionCell>()
//        vc.setItems(items: items)
//        vc.selectionItemsHandler = { data in
//
//        }
//        self.presentSheetModal(vc)
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
        let bottomSheet = BottomSheetController(preferredStyle: .list(items: items, appearance: .plain))
        //bottomSheet.allowsMultipleCollection = true
        bottomSheet.addHeaderSubview(SubtitleLabel(text: """
        이곳은 설정하기
        페이지 입니다
        낄낄
        """))
        bottomSheet.addHeaderSubview(TitleLabel(text: "설정하기"))

        let cancelAction = BottomSheetAction(title: "취소", style: .cancel)
        let saveAction = BottomSheetAction(title: "확인", style: .default) { items in
            let item = items.compactMap{ $0 as? ListItem }.first
            print(item?.name)
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
