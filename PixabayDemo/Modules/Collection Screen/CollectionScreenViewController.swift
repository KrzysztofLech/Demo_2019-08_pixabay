//
//  CollectionScreenViewController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit
import RealmSwift

final class CollectionScreenViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    var collections: Results<PictureCollection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        collections = DataManager.shared.fetchCollections()
    }
    
    private func setupCollectionView() {
        collectionView.registerCell(withXibName: CollectionCell.toString())
    }
}

extension CollectionScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let collection = collections?[indexPath.item],
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.toString(), for: indexPath) as? CollectionCell else { return UICollectionViewCell() }

        let title = collection.name
        let items = collection.items
        cell.configure(title: title, items: items)
        
        return cell
    }
}

extension CollectionScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
}
