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

final class ExViewController: UIViewController, CustomPanModalPresentable {
    
    var isShortFormEnabled = true
    
    private let dataSource: [ExSection] = [
        .first(
            ["Lemon🍋", "Orange🍊", "StrawBerry🍓", "WaterMelon🍉", "Apple🍎", "Cherry🍒"].map(ExSection.FirstItem.init(value:))
        ),
        .second(
            ["Moon🌙", "Mashroom🍄", "Fish🐠", "Star🌟", "Flower🌼"].map(ExSection.SecondItem.init(value:))
        ),
        .third(
            ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🎱", "🏸"].map(ExSection.ThirdItem.init(value:))
        )
    ]
    
    private let compositionalLayout: UICollectionViewCompositionalLayout = {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let badgeAnchor = NSCollectionLayoutAnchor(
                    edges: [.top, .trailing],
                    fractionalOffset: CGPoint(x: 0.4, y: -0.4)
                )
                let badgeSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(25),
                    heightDimension: .absolute(25)
                )
                let badge = NSCollectionLayoutSupplementaryItem(
                    layoutSize: badgeSize,
                    elementKind: BadgeView.identifier,
                    containerAnchor: badgeAnchor
                )
                
                let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                    elementKind: BackgroundDecorationView.backgroundDecorationElementKind)
                sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let itemFractionalWidthFraction = 1.0 / 3.0 // horizontal 3개의 셀
                let groupFractionalHeightFraction = 1.0 / 4.0 // vertical 4개의 셀
                let itemInset: CGFloat = 2.5
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(itemFractionalWidthFraction),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                section.decorationItems = [sectionBackgroundDecoration]
                
                return section
                
            case 1:
                let itemInset: CGFloat = 5.0
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .absolute(44)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary 
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
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .fractionalHeight(groupFractionalHeightFraction)
                )
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                  leading: .flexible(0),
                  top: nil,
                  trailing: .flexible(0),
                  bottom: nil
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
                
                // 해더/푸터/왼쪽뷰
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9),
                    heightDimension: .absolute(100.0)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: headerSize,
                  elementKind: UICollectionView.elementKindSectionHeader,
                  alignment: .topLeading
                )
                let footerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(100.0)
                )
                let footer = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: footerSize,
                  elementKind: UICollectionView.elementKindSectionFooter,
                  alignment: .bottom
                )
                
                let leftRightSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.1),
                    heightDimension: .fractionalHeight(0.5)
                )
                let left = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: leftRightSize,
                  elementKind: "LeftView",
                  alignment: .leading
                )
                let right = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: leftRightSize,
                  elementKind: "RightView",
                  alignment: .trailing
                )
                
                let headerFooterLeftRightSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.1),
                    heightDimension: .absolute(100)
                )
                let headerRight = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: headerFooterLeftRightSize,
                  elementKind: "HeaderRightView",
                  alignment: .topTrailing
                )
                let footerLeft = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: headerFooterLeftRightSize,
                  elementKind: "FooterLeftView",
                  alignment: .bottomLeading
                )
                
                let footerRight = NSCollectionLayoutBoundarySupplementaryItem(
                  layoutSize: headerFooterLeftRightSize,
                  elementKind: "FooterRightView",
                  alignment: .bottomTrailing
                )
                section.boundarySupplementaryItems = [header, footer, left, right, headerRight, footerLeft, footerRight]
                return section
            }
        }
        layout.register(BackgroundDecorationView.self, forDecorationViewOfKind: BackgroundDecorationView.backgroundDecorationElementKind)
        return layout
    }()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.backgroundColor = .red
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: "HeaderView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                      withReuseIdentifier: "FooterView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: "LeftView",
                      withReuseIdentifier: "LeftView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: "RightView",
                      withReuseIdentifier: "RightView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: "HeaderRightView",
                      withReuseIdentifier: "HeaderRightView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: "FooterLeftView",
                      withReuseIdentifier: "FooterLeftView")
        collectionView.register(ExHeaderFooterView.self,
                      forSupplementaryViewOfKind: "FooterRightView",
                      withReuseIdentifier: "FooterRightView")
        collectionView.register(BadgeView.self,
                                forSupplementaryViewOfKind: BadgeView.identifier,
                                withReuseIdentifier: BadgeView.identifier)
        collectionView.collectionViewLayout = self.compositionalLayout
        collectionView.dataSource = self
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
        guard isShortFormEnabled, case .longForm = state else { return }
        isShortFormEnabled = true
        panModalSetNeedsLayoutUpdate()
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
            cell.setBackgoundColor(with: .purple)
            cell.configure(with: items[indexPath.item].value)
        case let .third(items):
            cell.setBackgoundColor(with: .link)
            cell.configure(with: items[indexPath.item].value)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! ExHeaderFooterView
            header.configure(text: "스포츠헤더라능")
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! ExHeaderFooterView
            footer.configure(text: "스포츠푸터라능")
            return footer
        case "LeftView":
            let leftView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LeftView", for: indexPath) as! ExHeaderFooterView
            leftView.backgroundColor = .gray.withAlphaComponent(0.3)
            leftView.configure(text: "왼쪽ㅋ뷰라능", textColor: .black)
            return leftView
        case "RightView":
            let rightView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "RightView", for: indexPath) as! ExHeaderFooterView
            rightView.backgroundColor = .gray.withAlphaComponent(0.3)
            rightView.configure(text: "오른쪽ㅋ뷰라능", textColor: .black)
            return rightView
        case "HeaderRightView":
            let headerRightView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderRightView", for: indexPath) as! ExHeaderFooterView
            headerRightView.backgroundColor = .purple.withAlphaComponent(0.3)
            headerRightView.configure(text: "해더오른쪽", textColor: .black)
            return headerRightView
        case "FooterLeftView":
            let footerLeftView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterLeftView", for: indexPath) as! ExHeaderFooterView
            footerLeftView.backgroundColor = .purple.withAlphaComponent(0.3)
            footerLeftView.configure(text: "푸터왼쪽", textColor: .black)
            return footerLeftView
        case "FooterRightView":
            let footerRightView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterRightView", for: indexPath) as! ExHeaderFooterView
            footerRightView.backgroundColor = .purple.withAlphaComponent(0.3)
            footerRightView.configure(text: "푸터오른쪽", textColor: .black)
            return footerRightView
        case BadgeView.identifier:
            let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeView.identifier, for: indexPath) as! BadgeView
            return badgeView
        default:
            return UICollectionReusableView()
        }
    }
}
