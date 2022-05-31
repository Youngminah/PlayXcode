//
//  BottomSheetController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

class BottomSheetController: UIViewController, UICollectionViewDelegate {

    deinit {
        print("deinit")
    }

    enum Style {

        case list
        case grid2
        case custom

        var columnCount: Int {
            switch self {
            case .list:
                return 1
            case .grid2:
                return 2
            default:
                return 3
            }
        }
    }

    private enum Section {
        case main
    }

    private let dismissButton = XButton()
    private let headerStackView = UIStackView()
    private let buttonStackView = UIStackView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    private var collectionView: DynamicCollectionView! = nil

    private let contentView = UIView()
    private var isShortFormEnabled = true
    private var items: [ListItem]
    private let style: Style
    //private let layout: BottomSheetLayout

    var allowsMultipleCollection = false

    init(items: [ListItem], preferredStyle: BottomSheetController.Style) {
        self.items = items
        self.style = preferredStyle
        super.init(nibName: nil, bundle: nil)
    }

//    init(layout: BottomSheetLayout) {
//        self.layout = layout
//        super.init(nibName: nil, bundle: nil)
//    }

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
        var selectionItems: [ListItem] = []
        indexPaths.forEach { indexPath in
            selectionItems.append(items[indexPath.row])
        }
        self.dismiss(animated: true)
        sender.handler?(selectionItems)
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    func setItems(items: [ListItem]) {
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

    private func configureDataSource() {

        if #available(iOS 14.0, *) {
            let cellRegistration = UICollectionView.CellRegistration<TitleSelectionCell, ListItem> { (cell, indexPath, item) in
                cell.contentView.backgroundColor = .yellow
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                //cell.contentConfiguration
                cell.configure(item: item)
            }

            dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
                [weak self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
                guard let self = self else { return UICollectionViewCell() }
                let item = self.items.first(where: { $0.id == identifier})
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        } else {

            collectionView.register(TitleSelectionCell.self,
                                    forCellWithReuseIdentifier: TitleSelectionCell.identifier)
            dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) {
                [weak self] (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
                guard let self = self else { return UICollectionViewCell() }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleSelectionCell.identifier, for: indexPath as IndexPath) as! TitleSelectionCell
                cell.contentView.backgroundColor = .yellow
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                cell.configure(item: self.items[indexPath.row])
                return cell
            }
        }
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { $0.id })
        dataSource.apply(snapshot, animatingDifferences: false)
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

    var headerView: UIStackView? {
        return headerStackView
    }

    var footerButtonView: UIStackView? {
        return buttonStackView
    }

    var sheetScrollView: UIScrollView? {
        return collectionView
    }

//    var longFormHeight: SheetHeight {
//        return .maxHeight
//    }

    var anchorModalToLongForm: Bool {
        return false
    }

//    var shortFormHeight: SheetHeight {
//        return isShortFormEnabled ? .contentHeight(500) : longFormHeight
//    }

    func shouldPrioritize(panModalGestureRecognizer: UIPanGestureRecognizer) -> Bool {
        let location = panModalGestureRecognizer.location(in: view)
        return headerStackView.frame.contains(location) || buttonStackView.frame.contains(location)
    }

//    func willTransition(to state: SheetPresentationController.PresentationState) {
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

class BottomSheetAction: UIButton {

    enum Style {
        case `default`
        case cancel
        case destructive
    }

    private var title: String = ""
    private var style: BottomSheetAction.Style = .default

    var handler: (([ListItem]) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setConfiguration()
    }

    convenience init(title: String, style: BottomSheetAction.Style, handler: (([ListItem]) -> Void)? = nil) {
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
