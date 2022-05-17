//
//  SheetViewController.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

final class SheetViewController<T: SelectionCollectionViewCell>: UIViewController, UICollectionViewDelegate {

    private var items: [SelectionItem] = []

    enum Section {
        case main
    }

    private let dismissButton = XButton()
    private var dataSource: UICollectionViewDiffableDataSource<Section, SelectionItem>! = nil
    private var contentCollectionView: ContentCollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setConstraints()
        self.configureDataSource()
    }

    @objc func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    func setItems(items: [SelectionItem]) {
        self.items = items
    }

    private func setConstraints() {

        contentCollectionView = ContentCollectionView(frame: self.view.bounds,
                                                        collectionViewLayout: createLayout())
        contentCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentCollectionView.register(T.self, forCellWithReuseIdentifier: T.identifier)
        contentCollectionView.delegate = self
        contentCollectionView.allowsMultipleSelection = true

        view.addSubview(dismissButton)
        view.addSubview(contentCollectionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)

        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentCollectionView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16).isActive = true
        contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        contentCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func configureDataSource() {

        if #available(iOS 14.0, *) {
            let cellRegistration = UICollectionView.CellRegistration<T, SelectionItem> { (cell, indexPath, item) in

                cell.configure(text: item.name)
            }

            dataSource = UICollectionViewDiffableDataSource<Section, SelectionItem>(collectionView: contentCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: SelectionItem) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        } else {
            dataSource = UICollectionViewDiffableDataSource<Section, SelectionItem>(collectionView: contentCollectionView) {
                [weak self] (collectionView: UICollectionView, indexPath: IndexPath, item: SelectionItem) -> UICollectionViewCell? in
                guard let self = self else { return nil }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath as IndexPath) as! T

                let item = self.items[indexPath.row]
                cell.configure(text: item.name)
                return cell
            }
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, SelectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: false)
        //contentCollectionView.dataSource = dataSource
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        //print(collectionView.indexPathsForSelectedItems)
        //updateSelectedStateCellConfiguration(at: indexPath)
    }
}

extension SheetViewController {

    private func createLayout() -> UICollectionViewLayout {
        
        if #available(iOS 14.0, *) {

            let config = UICollectionLayoutListConfiguration(appearance: .grouped)
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
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(44.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            return layout
        }
    }

    func updateSelectedStateCellConfiguration(at indexPath: IndexPath) {
//        let index = indexPath.row
//        let isSelected = items[index].isSelected
//        for index in 0..<items.count {
//            items[index].isSelected = false
//        }
//        items[index].isSelected = !isSelected


        var snapshot = NSDiffableDataSourceSnapshot<Section, SelectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource.apply(snapshot)
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
