//
//  PixabaySearchResult.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

struct PixabayImageSearchResult: Decodable {
    
    public enum CodingKeys: String, CodingKey {
        case total
        case totalHits
        case items = "hits"
    }
    
    let total: Int
    let totalHits: Int
    let items: [PixabayImageItem]
}
