//
//  SplashScreenController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class SplashScreenController {
    
    private var serviceWorker: PixabayServiceWorkerProtocol?
    
    var collections: [PictureCollection] = []
    private let categories: [ApiParameters.Category] = [
        .greece, .girl, .city
    ]
    
    var images: [UIImage] = []      /// wykasować
    
    init() {
        serviceWorker = PixabayServiceWorker()
    }

    func fetchData(completion: @escaping (NetworkError?)->()) {
        let dispatchGroup = DispatchGroup()
        
        categories.forEach { [weak self] category in
            dispatchGroup.enter()
            
            serviceWorker?.getTopPopularPicturesFrom(category: category) { response in
                switch response {
                case .success(let data):
                    let tenMostViewedPictures = self?.findTenMostViewedPictures(items: data.items) ?? []
                    let collection = PictureCollection(name: category.rawValue.capitalized,
                                                       items: tenMostViewedPictures)
                    self?.collections.append(collection)
                    print(collection.name, collection.items.count)   //// to remove
                    
                case .failure(let error):
                    DispatchQueue.main.async { completion(error) }
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
    
    private func findTenMostViewedPictures(items: [PixabayImageItem]) -> [PixabayImageItem] {
        let sortedArray = items.sorted { $0.views > $1.views }
        return Array(sortedArray.prefix(10))
    }
    
    func downloadCollectionImages(completion: @escaping (NetworkError?)->()) {
        let allImages = collections.flatMap { $0.items }
        
        let dispatchGroup = DispatchGroup()
        
        allImages.forEach { [weak self] in
            dispatchGroup.enter()
            
            serviceWorker?.downloadImage(url: $0.largeImageURL) { result in
                switch result {
                case .success(let image):
                    self?.images.append(image!)
                    
                case .failure(let error):
                    DispatchQueue.main.async { completion(error) }
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
}
