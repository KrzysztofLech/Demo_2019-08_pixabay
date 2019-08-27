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
    case getTopPopularPictures(category: ApiParameters.Category)
    
    var baseURL: URL {
        return URL(string: "https://pixabay.com")!
    }
    
    var path: String {
        return "api/"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: NetworkTask {
        var parameters: NetworkParameters = [
            "key": "9485555-ef481e6738821b2b89a42b79c",
            "image_type": "photo",
        ]
        
        switch self {
        case .getPictureListWith(let searchTerm):
            parameters["per_page"] = 100
            parameters["q"] = searchTerm
            
        case .getTopPopularPictures(let category):
            parameters["orientation"] = ApiParameters.Orientation.horizontal.rawValue
            parameters["per_page"] = 200
            parameters["lang"] = "en"
            parameters["q"] = category.rawValue
        }
        
        return .requestParameters(parameters)
    }
    
    var headers: Headers? {
        let headers = Headers()
        return headers
    }
    
    var parametersEncoding: ParametersEncoding {
        return .url
    }
}
