//
//  CollectionCell.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 27/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    private enum Constants {
        static let lineSpacing: CGFloat = 8
        static let padding: CGFloat = 8
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!
    
    private var pixabayItems: [PixabayImageItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(withXibName: BigCell.toString())
        
        titleLabel.text = nil
        pixabayItems.removeAll()
    }
    
    func configure(title: String, items: [PixabayImageItem]) {
        titleLabel.text = title
        pixabayItems = items
    }
}

extension CollectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pixabayItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BigCell.toString(), for: indexPath) as? BigCell else { return UICollectionViewCell() }
        
        let imageId = pixabayItems[indexPath.row].id
        let image = ImageCacheService.shared.getFromCache(key: imageId)
        cell.configure(image: image)
        
        return cell
    }
}

extension CollectionCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width - Constants.padding * 2,
                      height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: Constants.padding, bottom: 0, right: Constants.padding)
    }
}

extension CollectionCell: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    private func scrollToNearestVisibleCollectionViewCell() {
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (collectionView.bounds.size.width / 2))
        var closestCellIndex: IndexPath?
        var closestDistance: Float = .greatestFiniteMagnitude
        
        collectionView.visibleCells.forEach {
            let cellWidth = $0.bounds.size.width
            let cellCenter = Float($0.frame.origin.x + cellWidth / 2)
            
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: $0)
            }
        }
        
        guard let indexItem = closestCellIndex?.item else { return }
        collectionView.scrollToItem(at: IndexPath(item: indexItem, section: 0), at: .centeredHorizontally, animated: true)
    }
}
