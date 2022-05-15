//
//  ContentView.swift
//  PlayXcode
//
//  Created by meng on 2022/05/12.
//

import UIKit

class ContentCollectionView: UICollectionView {

    let items = [CheckBoxItem(text: "한국어", isChecked: true), CheckBoxItem(text: "중국어", isChecked: false)]

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.register(LanguageCell.self, forCellWithReuseIdentifier: "SelectionCell")
        self.dataSource = self
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ContentCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCell", for: indexPath as IndexPath) as! LanguageCell
        let item = items[indexPath.row]
        cell.configure(text: item.text, isChecked: item.isChecked)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfSections section: Int) -> Int {
        return 1
    }
}


class BaseItem {

    let text: String

    init(text: String) {
        self.text = text
    }
}

final class CheckBoxItem: BaseItem, Hashable {

    let isChecked: Bool
    private let identifier = UUID()

    init(text: String, isChecked: Bool) {
        self.isChecked = isChecked
        super.init(text: text)
    }
}
