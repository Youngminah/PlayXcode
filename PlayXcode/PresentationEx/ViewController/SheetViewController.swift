//
//  SheetViewController.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

//final class SheetViewController<T: SelectionCollectionViewCell>: UIViewController, UICollectionViewDelegate {
//
//    private var items: [ListItem] = []
//    var selectionItemsHandler: (([ListItem]) -> Void)?
//
//    enum Section {
//        case main
//    }
//
//    private let dismissButton = XButton()
//    private let saveButton = UIButton()
//    private var dataSource: UICollectionViewDiffableDataSource<Section, ListItem>! = nil
//    private var contentCollectionView: UICollectionView! = nil
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setConstraints()
//        self.configureDataSource()
//        self.setConfiguration()
//    }
//
//    @objc func dismissButtonTap() {
//        self.dismiss(animated: true)
//    }
//
//    @objc func saveButtonTap() {
//        self.dismiss(animated: true)
//        self.selectionItemsHandler?(items)
//    }
//
//    func setItems(items: [ListItem]) {
//        self.items = items
//    }
//
//    private func setConstraints() {
//
//        contentCollectionView = ContentCollectionView(frame: self.view.bounds,
//                                                        collectionViewLayout: createLayout())
//        contentCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        contentCollectionView.delegate = self
//
//        view.addSubview(dismissButton)
//        view.addSubview(contentCollectionView)
//        view.addSubview(saveButton)
//
//        dismissButton.translatesAutoresizingMaskIntoConstraints = false
//        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
//        dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        dismissButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        dismissButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)
//
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
//        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
//
//        contentCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        contentCollectionView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16).isActive = true
//        contentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        contentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        contentCollectionView.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: -16).isActive = true
//    }
//
//    private func setConfiguration() {
//        contentCollectionView.allowsMultipleSelection = true
//        contentCollectionView.backgroundColor = .systemGroupedBackground
//
//        saveButton.setTitle("확인", for: .normal)
//        saveButton.setTitleColor(.white, for: .normal)
//        saveButton.backgroundColor = .orange
//        saveButton.layer.cornerRadius = 15
//        saveButton.layer.masksToBounds = true
//    }
//
//    private func configureDataSource() {
//
//        if #available(iOS 14.0, *) {
//            let cellRegistration = UICollectionView.CellRegistration<T, ListItem> { (cell, indexPath, item) in
//                cell.configure(text: item.name)
//            }
//
//            dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: contentCollectionView) {
//                (collectionView: UICollectionView, indexPath: IndexPath, item: ListItem) -> UICollectionViewCell? in
//                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
//            }
//        } else {
//            contentCollectionView.register(T.self, forCellWithReuseIdentifier: T.identifier)
//            dataSource = UICollectionViewDiffableDataSource<Section, ListItem>(collectionView: contentCollectionView) {
//                (collectionView: UICollectionView, indexPath: IndexPath, item: ListItem) -> UICollectionViewCell? in
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath as IndexPath) as! T
//                cell.configure(text: item.name)
//                return cell
//            }
//        }
//        // initial data
//        var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(items)
//        dataSource.apply(snapshot, animatingDifferences: false)
//        //contentCollectionView.dataSource = dataSource
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
//        //updateSelectedStateCellConfiguration(at: indexPath)
//    }
//}
//
//extension SheetViewController {
//
//    private func createLayout() -> UICollectionViewLayout {
//        
//        if #available(iOS 14.0, *) {
//
//            let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
//            return UICollectionViewCompositionalLayout.list(using: config)
//
//        } else {
//
//            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//
//                let itemInset: CGFloat = 5.0
//                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                      heightDimension: .fractionalHeight(1.0))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
//                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                       heightDimension: .estimated(60.0))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                return section
//            }
//            return layout
//        }
//    }
//
//    func updateSelectedStateCellConfiguration(at indexPath: IndexPath) {
////        let index = indexPath.row
////        let isSelected = items[index].isSelected
////        for index in 0..<items.count {
////            items[index].isSelected = false
////        }
////        items[index].isSelected = !isSelected
//
//
//        var snapshot = NSDiffableDataSourceSnapshot<Section, ListItem>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(items)
//
//        dataSource.apply(snapshot)
//    }
//}
//
//extension SheetViewController: SheetPresentable {
//
//    var sheetScrollView: UIScrollView? {
//        return contentCollectionView
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
//        return isShortFormEnabled ? .contentHeight(500.0) : longFormHeight
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
