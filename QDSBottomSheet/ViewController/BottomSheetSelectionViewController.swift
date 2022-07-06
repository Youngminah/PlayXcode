//
//  BottomSheetNoButtonViewController.swift
//  QDSBottomSheet
//
//  Created by Mint Kim on 2022/06/30.
//

import UIKit
import QDSKit

public protocol BottomSheetViewControllerDelegate: AnyObject {
    func bottomSheetDidSelect(item: Any)
    func bottomSheetDidSelect(indexPath: IndexPath)
    func bottomSheetWillAppear()
    func bottomSheetDidAppear()
    func bottomSheetWillDisappear()
    func bottomSheetDidDisappear()
}

public extension BottomSheetViewControllerDelegate {
    func bottomSheetDidSelect(item: Any) {}
    func bottomSheetDidSelect(indexPath: IndexPath) {}
    func bottomSheetWillAppear() {}
    func bottomSheetDidAppear() {}
    func bottomSheetWillDisappear() {}
    func bottomSheetDidDisappear() {}
}


open class BottomSheetSelectionViewController: UIViewController, UICollectionViewDelegate {

    private enum Section {
        case main
    }

    private let dismissButton = UIButton()
    private let headerStackView = UIStackView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private let style: BottomSheetStyle

    private var isShortFormEnabled = true

    public weak var delegate: BottomSheetViewControllerDelegate?

    public init(preferredStyle: BottomSheetStyle) {
        self.style = preferredStyle
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetController: fatal error")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setConfiguration()
        self.setConstraints()
        self.setDataSource()
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.bottomSheetWillAppear()
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.bottomSheetDidAppear()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.bottomSheetWillDisappear()
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.bottomSheetDidDisappear()
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        delegate?.bottomSheetDidSelect(indexPath: indexPath)
        //dismiss(animated: true)
    }
}

// MARK: - Private Method

extension BottomSheetSelectionViewController {

    private func setConfiguration() {
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

    private func setConstraints() {
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

    private func setDataSource() {
        switch style {
        case .list(let items, let appearance):
            switch appearance {
            case .plain:
                self.configureDataSource(cellType: TitleCell.self,
                                         items: items)
            case .checkBox:
                self.configureDataSource(cellType: TitleSelectionCell.self,
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

    private func createLayout() -> UICollectionViewLayout {
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
            self?.collectionView.selectItem(at: IndexPath(row: 2, section: 0), animated: false, scrollPosition: [])
        }
    }
}

extension BottomSheetSelectionViewController {

    public func addHeaderLabelSubview(_ view: UILabel) {
        headerStackView.addArrangedSubview(view)
    }

    public func addHeaderLabelSubviews(_ views: [UILabel]) {
        views.forEach { view in
            headerStackView.addArrangedSubview(view)
        }
    }
}

extension BottomSheetSelectionViewController: SheetPresentable {

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
