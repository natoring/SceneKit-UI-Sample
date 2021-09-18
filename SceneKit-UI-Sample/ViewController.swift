//
//  ViewController.swift
//  SceneKit-UI-Sample
//
//  Created by kohei on 2021/09/18.
//

import UIKit

class ViewController: UICollectionViewController {

    init() {
        let layout = UICollectionViewCompositionalLayout { index, environment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension:  .fractionalWidth(1.0),
                heightDimension: .absolute(100)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(
                top: 0,leading: 0, bottom: 10, trailing: 0)
            let groupSize = NSCollectionLayoutSize(
                widthDimension:  .fractionalWidth(1.0),
                heightDimension: .absolute(400)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        super.init(collectionViewLayout: layout)

        title = "SceneKit-UI-Sample"

        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .black
        cell.subviews.forEach({ $0.removeFromSuperview() })
        if cell.subviews.isEmpty {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 100))
            label.text = "Sample - \(indexPath.row)"
            label.textAlignment = .center
            label.textColor = .white
            cell.contentView.addSubview(label)
        }
        return cell
    }
}

