//
//  PictureCollection.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import RealmSwift

final class PictureCollection: Object {

    @objc dynamic var name: String = ""
    private let itemsList = List<PixabayImageItem>()

    convenience init(name: String, items: [PixabayImageItem]) {
        self.init()

        self.name = name
        self.itemsList.append(objectsIn: items)
    }
    
    var items: [PixabayImageItem] {
        var array: [PixabayImageItem] = []
        for item in itemsList {
            array.append(item)
        }
        return array
    }
}

//import Foundation
//
//final class PictureCollection {
//
//    let name: String
//    let items: [PixabayImageItem]
//
//    init(name: String, items: [PixabayImageItem]) {
//        self.name = name
//        self.items = items
//    }
//}
