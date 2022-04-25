//
//  Ex2ViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/25.
//

import UIKit

private let reuseIdentifier = "Cell"

class Ex2ViewController: UICollectionViewController {
    
    private let array = ["Lemon🍋", "Orange🍊", "StrawBerry🍓", "WaterMelon🍉", "Apple🍎"]

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension Ex2ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
}
