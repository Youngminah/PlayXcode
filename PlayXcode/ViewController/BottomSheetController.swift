//
//  BottomSheetController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

class BottomSheetController: UIViewController, UICollectionViewDelegate {

    enum Style {
        case list(items: [SelectionItem])
        case custom
    }

    private enum Section {
        case main
    }

    private let dismissButton = XButton()
    private let headerStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, SelectionItem>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private let contentView = UIView()
    private var isShortFormEnabled = true
    private var items: [SelectionItem] = []
    private let style: Style

    var allowsMultipleCollection = false

    init(preferredStyle: BottomSheetController.Style) {
        self.style = preferredStyle
        switch style {
        case .list(let items):
            self.items = items
        default:
            break
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("BottomSheetController: fatal error")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraints()
        self.configureDataSource()
        self.setConfiguration()
    }

    @objc func actionTap(_ sender: BottomSheetAction) {
        let indexPaths = collectionView.indexPathsForSelectedItems ?? []
        var selectionItems: [SelectionItem] = []
        indexPaths.forEach { indexPath in
            selectionItems.append(items[indexPath.row])
        }
        self.dismiss(animated: true)
        sender.handler?(selectionItems)
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    func setItems(items: [SelectionItem]) {
        self.items = items
    }

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

        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 1)
        contentViewHeightConstraint.priority = UILayoutPriority(rawValue: 251) // 251
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

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 10
    }

    private func createLayout() -> UICollectionViewLayout {

        if #available(iOS 14.0, *) {

            var config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            config.backgroundColor = .systemBackground
            return UICollectionViewCompositionalLayout.list(using: config)

        } else {

            let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

                let itemInset: CGFloat = 5.0
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: itemInset,
                                                             leading: itemInset,
                                                             bottom: itemInset,
                                                             trailing: itemInset)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .estimated(60.0))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            return layout
        }
    }

    private func configureDataSource() {

        if #available(iOS 14.0, *) {
            let cellRegistration = UICollectionView.CellRegistration<TitleSelectionCell, SelectionItem> { (cell, indexPath, item) in
                cell.configure(text: item.name)
            }

            dataSource = UICollectionViewDiffableDataSource<Section, SelectionItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: SelectionItem) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        } else {

            collectionView.register(TitleSelectionCell.self,
                                    forCellWithReuseIdentifier: TitleSelectionCell.identifier)
            dataSource = UICollectionViewDiffableDataSource<Section, SelectionItem>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: SelectionItem) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSelectionCell.identifier, for: indexPath as IndexPath) as! TitleSelectionCell
                cell.configure(text: item.name)
                return cell
            }
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, SelectionItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension BottomSheetController {

    func addHeaderSubview(_ view: UIView) {
        headerStackView.addArrangedSubview(view)
    }

    func addHeaderSubviews(_ views: [UIView]) {
        views.forEach { view in
            headerStackView.addArrangedSubview(view)
        }
    }

    func addBottomSheetAction(_ action: BottomSheetAction) {
        buttonStackView.addArrangedSubview(action)
        action.addTarget(self, action: #selector(self.actionTap(_:)), for: .touchUpInside)
    }

    func addBottomButtonSubviews(_ views: [BottomSheetAction]) {
        views.forEach { view in
            buttonStackView.addArrangedSubview(view)
        }
    }
}

extension BottomSheetController: SheetPresentable {

    var sheetScrollView: UIScrollView? {
        return collectionView
    }

    var longFormHeight: SheetHeight {
        return .maxHeight
    }

    var shortFormHeight: SheetHeight {
        return isShortFormEnabled ? .intrinsicHeight : longFormHeight
    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerStackView.frame.contains(location) || buttonStackView.frame.contains(location)
    }

    var anchorModalToLongForm: Bool {
        return true
    }

    func willTransition(to state: SheetPresentationController.PresentationState) {
        guard isShortFormEnabled, case .longForm = state else { return }
        //isShortFormEnabled = false
        sheetModalSetNeedsLayoutUpdate()
    }
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

class BottomSheetAction: UIButton {

    enum Style {
        case `default`
        case cancel
        case destructive
    }

    private var title: String = ""
    private var style: BottomSheetAction.Style = .default

    var handler: (([SelectionItem]) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(title: String, style: BottomSheetAction.Style, handler: (([SelectionItem]) -> Void)? = nil) {
        self.init()
        self.title = title
        self.style = style
        self.handler = handler
        self.setConfiguration()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.frame.size.height = 100
    }

    required init?(coder: NSCoder) {
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
