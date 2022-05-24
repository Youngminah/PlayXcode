//
//  NextViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

final class NextViewController: UIViewController, SheetPresentable, UICollectionViewDataSource {

    var isShortFormEnabled = true

    @IBOutlet weak var collectionView: UICollectionView!

    private let array = ["Lemon🍋", "Orange🍊", "StrawBerry🍓", "Cherry🍒"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
        cell.configure(with: array[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    var sheetScrollView: UIScrollView? {
        return collectionView
    }
//
//    var longFormHeight: SheetHeight {
//        return .intrinsicHeight
//    }
//
//    var isShortFormEnabled: Bool {
//        return true
//    }
//
    var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .contentHeight(500) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        sheetModalSetNeedsLayoutUpdate()
    }
}

extension NextViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 60)
    }
}
