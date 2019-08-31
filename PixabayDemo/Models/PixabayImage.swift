//
//  PixabayImage.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 31/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import RealmSwift

final class PixaBayImage: Object {
    @objc dynamic var id = 0
    @objc dynamic var previewSizeImageData: Data?
    @objc dynamic var originalSizeImageData: Data?
    
    convenience init(imageId: Int, previewSizeImageData: Data?) {
        self.init()
        
        self.id = imageId
        self.previewSizeImageData = previewSizeImageData
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
