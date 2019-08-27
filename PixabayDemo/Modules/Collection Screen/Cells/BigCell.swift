//
//  BigCell.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 26/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class BigCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }
    
    private func setup() {
        imageView.image = nil
    }
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
}
