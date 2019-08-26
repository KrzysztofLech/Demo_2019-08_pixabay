//
//  SplashScreenController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

protocol ProgressViewDelegate: AnyObject {
    func progressChanged(currentProgress: Float)
}

final class SplashScreenController {
    
    private enum Constants {
        static let topViewedPhotosNumber: Int = 10
    }
    
    private var serviceWorker: PixabayServiceWorkerProtocol?
    
    weak var delegate: ProgressViewDelegate?
    
    var collections: [PictureCollection] = []
    private let categories: [ApiParameters.Category] = [
        .greece, .girl, .city
    ]
    
    private lazy var progressStep: Float = {
        let steps = Float(categories.count * Constants.topViewedPhotosNumber)
        guard steps != 0 else { return 0 }
        return 1 / steps
    }()
    
    private var progress: Float = 0 {
        didSet {
            delegate?.progressChanged(currentProgress: progress)
        }
    }
    
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
        return Array(sortedArray.prefix(Constants.topViewedPhotosNumber))
    }
    
    func downloadCollectionImages(completion: @escaping (NetworkError?)->()) {
        let allImages = collections.flatMap { $0.items }
        
        let dispatchGroup = DispatchGroup()
        
        allImages.forEach { [weak self] in
            guard let self = self else { return }
            dispatchGroup.enter()
            
            serviceWorker?.downloadImage(url: $0.largeImageURL) { result in
                switch result {
                case .success(let image):
                    self.images.append(image!)
                    
                case .failure(let error):
                    DispatchQueue.main.async { completion(error) }
                }
                
                self.progress += self.progressStep
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
}
