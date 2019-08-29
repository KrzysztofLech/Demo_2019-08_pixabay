//
//  UICollectionView+extensions.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 29/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func registerCell(withXibName name: String) {
        register(UINib(nibName: name, bundle: nil), forCellWithReuseIdentifier: name)
    }
}
