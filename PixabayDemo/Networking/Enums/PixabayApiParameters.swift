//
//  PixabayApiParameters.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import Foundation

struct ApiParameters {
    
    enum Language: String {
        case en
        case pl
    }
    
    enum Orientation: String {
        case horizontal
        case vertical
    }
    
    enum Category: String {
        case greece = "greece+sea"
        case food
        case people
        case computer
        case city
        case girl
        case nature
        case cats
    }
    
    enum Order: String {
        case popular
        case latest
    }
}
