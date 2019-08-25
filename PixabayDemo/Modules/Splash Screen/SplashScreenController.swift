//
//  SplashScreenController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import Foundation

enum Progress {
    case error(NetworkError)
    case finish
    case progress(Float)
}

class SplashScreenController {
    
    private var serviceWorker: PixabayServiceWorkerProtocol?
    var collections: [PictureCollection] = []
    
    init() {
        serviceWorker = PixabayServiceWorker()
    }

    func fetchData(progressHandler: @escaping (Progress)->()) {
        serviceWorker?.getTopPopularPicturesFrom(category: .greece) { [weak self] response in
            switch response {
            case let .success(data):
                let collection = PictureCollection(name: "Greece", items: data.items)
                self?.collections.append(collection)
                print(collection.items.count)   //// to remove
                DispatchQueue.main.async {
                    progressHandler(.progress(50))
                    progressHandler(.finish)
                }
                
            case let .failure(error):
                DispatchQueue.main.async { progressHandler(.error(error)) }
            }
        }
    }
}
