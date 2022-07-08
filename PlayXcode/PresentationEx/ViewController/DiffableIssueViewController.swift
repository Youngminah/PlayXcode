//
//  DiffableIssueViewController.swift
//  PlayXcode
//
//  Created by meng on 2022/07/08.
//

import UIKit
import QDSKit

class DiffableIssueViewController: UIViewController, UICollectionViewDelegate {

    private enum Section {
        case main
    }

    private let dismissButton = UIButton()
    private let headerStackView = UIStackView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private let style: BottomSheetCollectionViewStyle

    private var isShortFormEnabled = true

    public init(preferredStyle: BottomSheetCollectionViewStyle) {
        self.style = preferredStyle
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetController: fatal error")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setConfiguration()
        self.setConstraints()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }
}

// MARK: - Private Method

extension BottomSheetNoButtonViewController {

    private func setConstraints() {
        dismissButton.addTarget(self,
                                action: #selector(dismissButtonTap),
                                for: .touchUpInside)
        collectionView = DynamicCollectionView(frame: .zero,
                                               collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self

        view.addSubview(dismissButton)
        view.addSubview(headerStackView)
        view.addSubview(collectionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let headerStackViewHeightConstraint = headerStackView.heightAnchor.constraint(equalToConstant: 0)
        headerStackViewHeightConstraint.priority = .defaultLow // 250
        headerStackViewHeightConstraint.isActive = true

        let collectionViewHeightConstraint = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

            collectionView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setConfiguration() {

        view.backgroundColor = .systemBackground

        headerStackView.axis = .vertical
        headerStackView.spacing = 5
        headerStackView.distribution = .fillProportionally
        headerStackView.alignment = .fill

        collectionView.backgroundColor = .systemBackground

        dismissButton.setImage(QDS.Icon.cancel20, for: .normal)
    }

    private func createLayout() -> UICollectionViewLayout {
        return SheetLayout.layout(layoutKind: style)
    }
}

extension BottomSheetNoButtonViewController: SheetPresentable {

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
