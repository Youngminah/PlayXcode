//
//  BottomSheetViewController.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/07/07.
//

import UIKit
import QDSKit

class BottomSheetViewController: UIViewController, UICollectionViewDelegate {

    fileprivate enum Section {
        case main
    }

    private let dismissButton = UIButton()
    private let headerStackView = UIStackView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private let style: BottomSheetStyle
    private var defaultSelectionItem: Int
    private var isShortFormEnabled = true

    public init(preferredStyle: BottomSheetStyle, defaultSelectionItem: Int = 0) {
        self.style = preferredStyle
        self.defaultSelectionItem = defaultSelectionItem
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfiguration()
        self.setConstraints()
        self.setDataSource()
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }

    func setConfiguration() {
        dismissButton.addTarget(self,
                                action: #selector(dismissButtonTap),
                                for: .touchUpInside)
        collectionView = DynamicCollectionView(frame: .zero,
                                               collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self

        view.backgroundColor = .systemBackground

        headerStackView.axis = .vertical
        headerStackView.spacing = 5
        headerStackView.distribution = .fillProportionally
        headerStackView.alignment = .fill

        collectionView.backgroundColor = .systemBackground

        dismissButton.setImage(QDS.Icon.cancel20, for: .normal)
    }

    func setConstraints() {
        view.addSubview(dismissButton)
        view.addSubview(headerStackView)
        view.addSubview(collectionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let headerStackViewHeightConstraint = headerStackView.heightAnchor.constraint(equalToConstant: 1)
        headerStackViewHeightConstraint.priority = .defaultLow // 250
        headerStackViewHeightConstraint.isActive = true

        let collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 20)
        collectionViewHeightConstraint.priority = UILayoutPriority(rawValue: 255) // 251
        collectionViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 20),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),

            headerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            headerStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setDataSource() {
        switch style {
        case .list(let items, let appearance):
            switch appearance {
            case .plain:
                self.configureDataSource(cellType: TitleCell.self,
                                         items: items)
            case .checkBox:
                self.configureDataSource(cellType: SubTitleSelectionCell.self,
                                         items: items)
            }
        case .grid2(let items, let appearance):
            switch appearance {
            case .plain:
                self.configureDataSource(cellType: TitleCell.self,
                                         items: items)
            case .checkBox:
                self.configureDataSource(cellType: TitleSelectionCell.self,
                                         items: items)
            }
        }
    }

    func createLayout() -> UICollectionViewLayout {
        return BottomSheetLayout.layout(layoutKind: style)
    }

    private func configureDataSource<Cell: BottomSheetCell>(
        cellType: Cell.Type,
        items: [Cell.Item]
    ) {

        if #available(iOS 14.0, *) {
            let cellRegistration = UICollectionView.CellRegistration<Cell, Cell.Item> { (cell, indexPath, item) in
                cell.configure(item: item)
            }

            dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
                let item = items.first(where: { $0.id == identifier})
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        } else {

            collectionView.register(Cell.self,
                                    forCellWithReuseIdentifier: Cell.identifier)
            dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath as IndexPath) as! Cell
                cell.configure(item: items[indexPath.row])
                return cell
            }
        }

        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems( items.map { $0.id } )
        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(row: self.defaultSelectionItem, section: 0)
            self.collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        }
    }
}

extension BottomSheetViewController {

    public func addHeaderLabelSubview(_ view: UILabel) {
        headerStackView.addArrangedSubview(view)
    }

    public func addHeaderLabelSubviews(_ views: [UILabel]) {
        views.forEach { view in
            headerStackView.addArrangedSubview(view)
        }
    }
}

extension BottomSheetViewController: SheetPresentable {

    public var headerView: UIStackView? {
        return headerStackView
    }

    public var footerButtonView: UIStackView? {
        return nil
    }

    public var sheetScrollView: UIScrollView? {
        return collectionView
    }

    public var longFormHeight: SheetHeight {
        return .maxHeight
    }

    public var anchorModalToLongForm: Bool {
        return false
    }

    public var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .intrinsicHeight : longFormHeight
    }

    public func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerStackView.frame.contains(location)
    }
}
