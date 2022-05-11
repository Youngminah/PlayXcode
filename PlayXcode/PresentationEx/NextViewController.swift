//
//  NextViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/28.
//

import UIKit

final class NextViewController: UIViewController, CustomPanModalPresentable, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!

    private let array = ["Lemon🍋", "Orange🍊", "StrawBerry🍓", "Cherry🍒"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
        cell.configure(with: array[indexPath.row])
        return cell
    }

    var panScrollable: UIScrollView? {
        return collectionView
    }

    var longFormHeight: PanModalHeight {
        return .maxHeight
    }

    var isShortFormEnabled: Bool {
        return false
    }

    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    func willTransition(to state: CustomPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        //isShortFormEnabled = true
        panModalSetNeedsLayoutUpdate()
    }
}

extension NextViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 2, height: 60)
    }
}
