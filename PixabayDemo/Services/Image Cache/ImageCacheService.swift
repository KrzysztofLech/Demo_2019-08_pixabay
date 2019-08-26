//
//  ImageCacheService.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 26/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    private var cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func cache(object: UIImage, forKey key: Int) {
        guard getFromCache(key: key) == nil else {
            //print("Nie zapisano: ", key)
            return
        }
        
        let keyString = String(key)
        cache.setObject(object, forKey: keyString as NSString)
        //print("Zapisano: ", key)
    }
    
    func getFromCache(key: Int) -> UIImage? {
        let keyString = String(key)
        return cache.object(forKey: keyString as NSString)
    }
}
