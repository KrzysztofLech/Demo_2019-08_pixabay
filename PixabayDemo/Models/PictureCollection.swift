//
//  PictureCollection.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

final class PictureCollection {

    let name: String
    let items: [PixabayImageItem]

    init(name: String, items: [PixabayImageItem]) {
        self.name = name
        self.items = items
    }
}
