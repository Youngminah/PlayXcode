//
//  Ex2ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/25.
//

import UIKit

private let reuseIdentifier = "Cell"

final class Ex2ViewController: UICollectionViewController, SheetPresentable {
    var headerView: UIStackView? {
        return nil
    }

    var footerButtonView: UIStackView? {
        return nil
    }


    var isShortFormEnabled = true
    
    private let array = ["Lemon🍋", "Orange🍊"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
        cell.configure(with: array[indexPath.row])
        return cell
    }

    var sheetScrollView: UIScrollView? {
        return collectionView
    }

//    var longFormHeight: SheetHeight {
//        return .maxHeight
//    }

//    var isShortFormEnabled: Bool {
//        return true
//    }
//
    var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .contentHeight(500.0) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        isShortFormEnabled = false
        sheetModalSetNeedsLayoutUpdate()
    }
}

extension Ex2ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}
