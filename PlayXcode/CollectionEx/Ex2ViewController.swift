//
//  Ex2ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class Ex2ViewController: UICollectionViewController, CustomPanModalPresentable {
    
    private let array = ["Lemon🍋", "Orange🍊", "StrawBerry🍓", "WaterMelon🍉", "Apple🍎"]
    var isShortFormEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.bounce
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
        cell.configure(with: array[indexPath.row])
        return cell
    }
    
    var panScrollable: UIScrollView? {
        return collectionView
    }

    var shortFormHeight: PanModalHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return false
    }

    func willTransition(to state: CustomPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state
            else { return }

        isShortFormEnabled = false
        panModalSetNeedsLayoutUpdate()
    }
}

extension Ex2ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}
