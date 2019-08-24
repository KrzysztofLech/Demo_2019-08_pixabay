//
//  PixabayService.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import Foundation

enum PixabayService: ServiceProtocol {
    case getPictureListWith(searchTerm: String)
    
    var baseURL: URL {
        return URL(string: "https://pixabay.com")!
    }
    
    var path: String {
        switch self {
        case .getPictureListWith:
            return "api/"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: NetworkTask {
        switch self {
        case .getPictureListWith(let searchTerm):
            let parameters: NetworkParameters = [
                "key": "9485555-ef481e6738821b2b89a42b79c",
                "image_type": "photo",
                "per_page": 100,
                "g": searchTerm
            ]
            return .requestParameters(parameters)
        }
    }
    
    var headers: Headers? {
        let headers = Headers()
        return headers
    }
    
    var parametersEncoding: ParametersEncoding {
        switch self {
        case .getPictureListWith: return .url
        }
    }
}
