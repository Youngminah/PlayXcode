//
//  ExViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/25.
//

import UIKit

enum ExSection {
    case first([FirstItem])
    case second([SecondItem])
    case third([ThirdItem])
    
    struct FirstItem {
        let value: String
    }
    struct SecondItem {
        let value: String
    }
    struct ThirdItem {
        let value: String
    }
}

final class ExViewController: UIViewController {
    
//    private let array = [
//        "Lemon🍋", "Orange🍊", "StrawBerry🍓",
//        "WaterMelon🍉", "Apple🍎", "Cherry🍒"
//    ]
    
    private let dataSource: [ExSection] = [
        .first(
            ["Lemon🍋", "Orange🍊", "StrawBerry🍓","WaterMelon🍉", "Apple🍎", "Cherry🍒"].map(ExSection.FirstItem.init(value:))
        ),
        .second(
            ["Moon🌙", "Mashroom🍄", "Fish🐠","Star🌟", "Flower🌼"].map(ExSection.SecondItem.init(value:))
        ),
        .third(
            ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐"].map(ExSection.ThirdItem.init(value:))
        )
    ]
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                return section
                
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(44)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
                
            default:
                let itemFractionalWidthFraction = 1.0 / 5.0
                let groupFractionalHeightFraction = 1.0 / 4.0
                let itemInset: CGFloat = 2.5
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                return section
            }
        }
        return layout
    }()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = self.compositionalLayout
        collectionView.dataSource = self
    }
}

extension ExViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.dataSource[section] {
        case let .first(items):
            return items.count
        case let .second(items):
            return items.count
        case let .third(items):
            return items.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExCell.identifier, for: indexPath) as! ExCell
        
        switch self.dataSource[indexPath.section] {
        case let .first(items):
            cell.setBackgoundColor(with: .orange)
            cell.configure(with: items[indexPath.item].value)
        case let .second(items):
            cell.setBackgoundColor(with: .systemMint)
            cell.configure(with: items[indexPath.item].value)
        case let .third(items):
            cell.setBackgoundColor(with: .systemPink)
            cell.configure(with: items[indexPath.item].value)
        }
        return cell
    }
}

//extension ExViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.bounds.width/2, height: 60)
//    }
//}
