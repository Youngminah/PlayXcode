//
//  Ex3ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

final class Ex3ViewController: BottomSheetViewController {

    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()

    private let cancelButton = SelectionButton(title: "취소")
    private let confirmButton = SelectionButton(title: "확인")

    override func viewDidLoad() {
        super.viewDidLoad()

        setConfigurations()
        contentView.backgroundColor = .yellow

        addHeaderSubviews([titleLabel, subTitleLabel])
        addBottomButtonSubviews([cancelButton, confirmButton])

        //self.view.addSubview(UIView())
    }


    private func setConfigurations() {
        
        titleLabel.text = "설정하기"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)

        subTitleLabel.text = """
        이곳은 설정하기
        페이지 입니다
        낄낄
        """
        subTitleLabel.font = .systemFont(ofSize: 14, weight: .light)
        subTitleLabel.textColor = .gray
        subTitleLabel.numberOfLines = 0
    }
}

class Button3View: UIView {

}
extension Ex3ViewController: SheetPresentable {

//
//    override var contentViewInset: UIEdgeInsets {
//        .init(top: 20, left: 0, bottom: 0, right: 0)
//    }

    var sheetScrollView: UIScrollView? {
        nil
    }

    var longFormHeight: SheetHeight {
        return .maxHeight
    }

    var isShortFormEnabled: Bool {
        return true
    }

    var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .intrinsicHeight : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        sheetModalSetNeedsLayoutUpdate()
    }
}
