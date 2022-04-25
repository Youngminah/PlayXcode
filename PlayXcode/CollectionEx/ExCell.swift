//
//  ExCell.swift
//  PlayXcode
//
//  Created by Mint Kim on 2022/04/25.
//

import UIKit

class ExCell: UICollectionViewCell {
    
    static let identifier = "ExCell"
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with text : String) {
        label.text = text
    }
    
    func setBackgoundColor(with color: UIColor) {
        contentView.backgroundColor = color
    }
}
