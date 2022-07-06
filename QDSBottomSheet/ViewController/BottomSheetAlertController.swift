//
//  BottomSheetController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

open class BottomSheetAlertController: UIViewController, UICollectionViewDelegate {

    private enum Section {
        case main
    }

    private let dismissButton = XButton()
    private let headerStackView = UIStackView()
    private let contentView = UIView()
    private let buttonStackView = UIStackView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private var isShortFormEnabled = true
    private let style: BottomSheetStyle

    var allowsMultipleCollection = false
    weak var delegate: BottomSheetViewControllerDelegate?

    public init(preferredStyle: BottomSheetStyle) {
        self.style = preferredStyle
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetController: fatal error")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraints()
        self.setDataSource()
        self.setConfiguration()
    }

    @objc func actionTap(_ sender: BottomSheetAction) {
        let indexPaths = collectionView.indexPathsForSelectedItems ?? []
        var selectionItems: [BottomSheetAction.Item] = []

        let items = style.items
        indexPaths.forEach { indexPath in
            selectionItems.append(items[indexPath.row])
        }
        self.dismiss(animated: true)
        sender.handler?(selectionItems)
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
}

extension BottomSheetAlertController {

    public func addHeaderLabelSubview(_ view: UILabel) {
        headerStackView.addArrangedSubview(view)
    }

    public func addHeaderLabelSubviews(_ views: [UILabel]) {
        views.forEach { view in
            headerStackView.addArrangedSubview(view)
        }
    }

    public func addBottomSheetAction(_ action: BottomSheetAction) {
        buttonStackView.addArrangedSubview(action)
        action.addTarget(self, action: #selector(self.actionTap(_:)), for: .touchUpInside)
    }

    public func addBottomButtonSubviews(_ views: [BottomSheetAction]) {
        views.forEach { view in
            buttonStackView.addArrangedSubview(view)
        }
    }
}

// MARK: - Private Method

extension BottomSheetAlertController {
    
    private func setConstraints() {
        dismissButton.addTarget(self,
                                action: #selector(dismissButtonTap),
                                for: .touchUpInside)
        collectionView = DynamicCollectionView(frame: .zero,
                                               collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = allowsMultipleCollection

        view.addSubview(dismissButton)
        view.addSubview(headerStackView)
        view.addSubview(contentView)
        view.addSubview(buttonStackView)
        contentView.addSubview(collectionView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        let headerStackViewHeightConstraint = headerStackView.heightAnchor.constraint(equalToConstant: 0)
        headerStackViewHeightConstraint.priority = .defaultLow // 250
        headerStackViewHeightConstraint.isActive = true

        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 20)
        contentViewHeightConstraint.priority = UILayoutPriority(rawValue: 255) // 251
        contentViewHeightConstraint.isActive = true

        let buttonStackViewHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: 0)
        buttonStackViewHeightConstraint.priority = .defaultLow // 250
        buttonStackViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 20),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),

            headerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            headerStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            buttonStackView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setConfiguration() {

        view.backgroundColor = .systemBackground

        headerStackView.axis = .vertical
        headerStackView.spacing = 5
        headerStackView.distribution = .fillProportionally
        headerStackView.alignment = .fill

        collectionView.backgroundColor = .systemBackground

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 10
    }

    private func createLayout() -> UICollectionViewLayout {
        return BottomSheetLayout.layout(layoutKind: style)
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
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension BottomSheetAlertController: SheetPresentable {

    public var headerView: UIStackView? {
        return headerStackView
    }

    public var footerButtonView: UIStackView? {
        return buttonStackView
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
        return headerStackView.frame.contains(location) || buttonStackView.frame.contains(location)
    }

//    public func willTransition(to state: SheetPresentationController.PresentationState) {
//        guard isShortFormEnabled, case .longForm = state else { return }
//        //isShortFormEnabled = false
//        sheetModalSetNeedsLayoutUpdate()
//    }
}

class DynamicCollectionView: UICollectionView {

    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}

open class BottomSheetAction: UIButton {

    public typealias Item = Any

    public enum Style {
        case `default`
        case cancel
        case destructive
    }

    private var title: String = ""
    private var style: BottomSheetAction.Style = .default

    public var handler: (([Item]) -> Void)?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    public convenience init(title: String, style: BottomSheetAction.Style, handler: (([Item]) -> Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
        self.setConfiguration()
    }

    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame.size.height = 100
    }

    public required init?(coder: NSCoder) {
        fatalError("BottomSheetAction: fatal Error Message")
    }

    private func setConfiguration() {

        layer.masksToBounds = true
        layer.cornerRadius = 8
        titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        setTitle(title, for: .normal)
        setTitleColor(.white, for: .normal)

        switch style {
        case .`default`:
            backgroundColor = .orange
        case .cancel:
            backgroundColor = .lightGray
        case .destructive:
            backgroundColor = .red
        }
    }
}
