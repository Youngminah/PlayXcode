//
//  Ex3ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

//final class Ex4ViewController: BottomSheetViewController{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addHeaderSubviews([
//
//        ])
//
//        addBottomButtonSubviews([
//
//        ])
//
////        addContentView
//
//
//    }
//}
//
//final class Ex5ViewController: BottomSheetViewController{
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        addHeaderSubviews([
//
//        ])
//
//        addBottomButtonSubviews([
//
//        ])
//
////        addContentView
//
//
//    }
//}
//
//class Ex6ViewController: UIViewController {
//
//    func touch() {
//        let bottom = BottomSheetViewController()
//        bottom.addHeades = [
//
//        ]
//        bottom = [
//            AcctionButton() {
//
//            },
//
//        ]
//
//
//        self.present(bottom, animated: true, completion: nil)
//    }
//}

//final class Ex3ViewController: BottomSheetController, UICollectionViewDataSource {
//
//    private let titleLabel = UILabel()
//    private let subTitleLabel = UILabel()
//
//    private let collectionView = DynamicCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//    private let cancelButton = BottomSheetAction(title: "취소", style: .cancel)
//    private let confirmButton = BottomSheetAction(title: "확인", style: .default)
//
//    private let array = ["Lemon🍋", "Orange🍊"]
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setConfigurations()
//        contentView.backgroundColor = .yellow
//        collectionView.delegate = self
//        collectionView.dataSource = self
//
//        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        flowLayout.itemSize = CGSize(width: 100, height: 100)
//        collectionView.collectionViewLayout = flowLayout
//        
//        addHeaderSubviews([titleLabel, subTitleLabel])
//        addBottomButtonSubviews([cancelButton, confirmButton])
//        contentView.addSubview(collectionView)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
//        ])
//    }
//
//    private func setConfigurations() {
//        
//        titleLabel.text = "설정하기"
//        titleLabel.textColor = .label
//        titleLabel.font = .systemFont(ofSize: 25, weight: .semibold)
//
//        subTitleLabel.text = """
//        이곳은 설정하기
//        페이지 입니다
//        낄낄
//        """
//        subTitleLabel.font = .systemFont(ofSize: 14, weight: .light)
//        subTitleLabel.textColor = .gray
//        subTitleLabel.numberOfLines = 0
//    }
//
//    // MARK: - UICollectionViewDataSource
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return array.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
//        cell.configure(with: array[indexPath.row])
//        return cell
//    }
//}
//
//class CustomView: UIView {
//
//}

//extension Ex3ViewController: SheetPresentable {
//    var sheetScrollView: UIScrollView? {
//        return collectionView
//    }
//
//    var longFormHeight: SheetHeight {
//        return .maxHeight
//    }
//
//    var isShortFormEnabled: Bool {
//        return true
//    }
//
//    var shortFormHeight: SheetHeight {
//        return isShortFormEnabled ? .intrinsicHeight : longFormHeight
//    }
//
//    var anchorModalToLongForm: Bool {
//        return true
//    }
//
//    func willTransition(to state: SheetPresentationController.PresentationState) {
//        guard isShortFormEnabled, case .longForm = state else { return }
//        sheetModalSetNeedsLayoutUpdate()
//    }
//}
