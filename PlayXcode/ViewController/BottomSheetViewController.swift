//
//  BottomSheetViewController.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/20.
//

import UIKit

class BottomSheetViewController: UIViewController {


    private let dismissButton = XButton()
    private let headerStackView = UIStackView()
    private let buttonStackView = UIStackView()
    
   private let contentView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setConstraints()
        self.setConfiguration()
    }

    var contentViewA: UIView? {
        nil
    }

    var contentViewInset: UIEdgeInsets {
        .zero
    }

    @objc private func dismissButtonTap() {
        self.dismiss(animated: true)
    }

    private func setConstraints() {

        view.addSubview(dismissButton)
        view.addSubview(headerStackView)
        view.addSubview(contentView)
        view.addSubview(buttonStackView)

        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        headerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissButtonTap), for: .touchUpInside)

        let headerStackViewHeightConstraint = headerStackView.heightAnchor.constraint(equalToConstant: 0)
        headerStackViewHeightConstraint.priority = .defaultLow // 250
        headerStackViewHeightConstraint.isActive = true

        let contentViewHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: 0)
        contentViewHeightConstraint.priority = .defaultLow // 250
        contentViewHeightConstraint.isActive = true

        let buttonStackViewHeightConstraint = buttonStackView.heightAnchor.constraint(equalToConstant: 0)
        buttonStackViewHeightConstraint.priority = .defaultLow // 250
        buttonStackViewHeightConstraint.isActive = true

        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dismissButton.widthAnchor.constraint(equalToConstant: 20),
            dismissButton.heightAnchor.constraint(equalToConstant: 20),

            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            headerStackView.topAnchor.constraint(equalTo: dismissButton.bottomAnchor, constant: 16),

            contentView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            buttonStackView.topAnchor.constraint(equalTo: contentView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }

    private func setConfiguration() {
        view.backgroundColor = .systemBackground

        headerStackView.axis = .vertical
        headerStackView.spacing = 12
        headerStackView.distribution = .fillEqually
        headerStackView.alignment = .fill

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        buttonStackView.alignment = .fill
        buttonStackView.spacing = 10
    }
}

extension BottomSheetViewController {

    func addHeaderSubview(_ view: UIView) {
        headerStackView.addArrangedSubview(view)
        view.layoutIfNeeded()
        let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
    }

    func addHeaderSubviews(_ views: [UIView]) {
        views.forEach { view in
            headerStackView.addArrangedSubview(view)
        }
        view.layoutIfNeeded()
        let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height
        
    }

    func addBottomButtonSubview(_ view: UIView) {
        buttonStackView.addArrangedSubview(view)
        view.layoutIfNeeded()
        let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height

    }

    func addBottomButtonSubviews(_ views: [UIView]) {
        views.forEach { view in
            buttonStackView.addArrangedSubview(view)
        }
        view.layoutIfNeeded()
        let targetSize = CGSize(width: UIScreen.main.bounds.width,
                                height: UIView.layoutFittingCompressedSize.height)
        let intrinsicHeight = view.systemLayoutSizeFitting(targetSize).height

    }
}
