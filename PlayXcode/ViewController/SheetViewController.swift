//
//  SheetViewController.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

final class SheetViewController: UIViewController {

    let items = [
        CheckBoxItem(text: "한국어", isChecked: true),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false),
        CheckBoxItem(text: "중국어", isChecked: false)
    ]

    enum Section {
        case main
    }

    private let dismissButton = XButton()

    private var dataSource: UICollectionViewDiffableDataSource<Section, CheckBoxItem>! = nil
    private var contentCollectionView: ContentCollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraints()
    }

    private func setConstraints() {
        
        contentCollectionView = ContentCollectionView(frame: self.view.bounds,
                                                        collectionViewLayout: createLayout())
        contentCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(dismissButton)
        view.addSubview(contentCollectionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)

        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.topAnchor.constraint(equalTo: dismissButton.topAnchor, constant: 16).isActive = true
        contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    @objc func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    private func configureDataSource() {
        if #available(iOS 14.0, *) {
            let cellRegistration = UICollectionView.CellRegistration<LanguageCell, CheckBoxItem> { (cell, indexPath, item) in
                cell.configure(text: item.text, isChecked: item.isChecked)
            }

            dataSource = UICollectionViewDiffableDataSource<Section, CheckBoxItem>(collectionView: contentCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: CheckBoxItem) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        } else {
            dataSource = UICollectionViewDiffableDataSource<Section, CheckBoxItem>(collectionView: contentCollectionView) {
                [weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: CheckBoxItem) -> UICollectionViewCell? in
                guard let self = self else { return nil }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LanguageCell.identifier, for: indexPath as IndexPath) as! LanguageCell
                let item = self.items[indexPath.row]
                cell.configure(text: item.text, isChecked: item.isChecked)
                return cell
            }
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, CheckBoxItem>()
        snapshot.appendSections([.main])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SheetViewController {

    private func createLayout() -> UICollectionViewLayout {
        if #available(iOS 14.0, *) {
            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            return UICollectionViewCompositionalLayout.list(using: config)
        } else {
            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

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
            }()
        }
    }
}

extension SheetViewController: SheetPresentable {

    var sheetScrollView: UIScrollView? {
        return contentCollectionView
    }

    var longFormHeight: SheetHeight {
        return .maxHeight
    }

    var isShortFormEnabled: Bool {
        return false
    }

    var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .contentHeight(300.0) : longFormHeight
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        sheetModalSetNeedsLayoutUpdate()
    }
}
