//
//  SelectionCollectionView.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/05/11.
//

import UIKit

//class SelectionCollectionView: UICollectionView {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//
//    private let checkButton: UIButton = {
//        let button = UIButton()
//        let image = UIImage(systemName: "checkmark.rect")
//        button.setImage(image, for: .normal)
//        return button
//    }()
//
//    private let contentLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .white
//        label.font = .systemFont(ofSize: 15, weight: .heavy)
//        return label
//    }()
//
//    override init(frame: CGRect) { // 코드로 뷰가 생성될 때 생성자
//        super.init(frame: frame)
//        //self.setContraints()
//    }
//
//    required init?(coder: NSCoder) { //스토리보드로 뷰가 생성될 때 생성자
//        super.init(coder: coder)
//    }
//
//    private func setContraints(){
//        addSubview(checkButton)
//        addSubview(contentLabel)
//
//        //위에 대체코드 -_-
//        NSLayoutConstraint.activate([
//            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            imageView.topAnchor.constraint(equalTo: topAnchor),
//            imageView.widthAnchor.constraint(equalTo: widthAnchor),
//            imageView.heightAnchor.constraint(equalTo: heightAnchor),
//
//            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//            dateLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: 16),
//        ])
//    }
//}
