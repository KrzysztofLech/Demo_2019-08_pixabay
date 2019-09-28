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
        static let topViewedPhotosNumber: Int = 2
    }
    
    weak var delegate: ProgressViewDelegate?
    
    private let serviceWorker: PixabayServiceWorkerProtocol
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
            DispatchQueue.main.async {
                self.delegate?.progressChanged(currentProgress: self.progress)
            }
        }
    }
    
    // MARK: - Init method
    
    init() {
        serviceWorker = PixabayServiceWorker()
    }
    
    // MARK: - Fetching methods

    func fetchData(completion: @escaping (NetworkError?)->()) {
        DataManager.shared.deleteAll()
    
        let dispatchGroup = DispatchGroup()

        categories.forEach { [weak self] category in
            dispatchGroup.enter()

            serviceWorker.getTopPopularPicturesFrom(category: category) { response in
                switch response {
                case .success(let data):
                    self?.createCollection(withData: data.items, andCategory: category)
                    
                case .failure(let error): completion(error)
                }
                
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
        
    private func createCollection(withData data: [PixabayImageItem], andCategory category: ApiParameters.Category) {
        let tenMostViewedPictures = findMostViewedPictures(items: data)
        let collection = PictureCollection(name: category.rawValue.capitalized,
                                           items: tenMostViewedPictures)
        DataManager.shared.addObject(object: collection)
                
        print(collection.name, collection.items.count)   //// to remove
    }
    
    private func findMostViewedPictures(items: [PixabayImageItem]) -> [PixabayImageItem] {
        let sortedArray = items.sorted { $0.views > $1.views }
        return Array(sortedArray.prefix(Constants.topViewedPhotosNumber))
    }
    
    
    
    
    // MARK: - Images downloading methods
    
    func downloadCollectionImages(completion: @escaping (NetworkError?)->()) {
        let allItems = DataManager.shared.fetchAllImageItems()
        
        print("$$$$$$$: ", allItems.count)
        
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
//
//        allItems.forEach { [weak self] item in
//            guard let self = self else { return }
//
//            let operation = ImageDownloadOperation(url: item.largeImageURL, completionHandler: { image in
//                if let image = image {
//                    ImageCacheService.shared.cache(object: image, forKey: item.id)
//                    self.progress += self.progressStep
//                    print("Finished downloading: ", item.id)
//                } else {
//                    print("!! Problem with downloading: ", item.id)
//                }
//            })
//            queue.addOperation(operation)
//        }
//
//        queue.addOperation {
//            DispatchQueue.main.async { completion(nil) }
//        }
    }
}
