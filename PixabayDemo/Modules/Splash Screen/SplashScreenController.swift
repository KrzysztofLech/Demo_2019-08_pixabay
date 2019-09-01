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
        static let topViewedPhotosNumber: Int = 4
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
            DispatchQueue.main.async {
                self.delegate?.progressChanged(currentProgress: self.progress)
            }
        }
    }
    
    
    // MARK: - Init method
    // //////////////////////////////////////////////////////////////////////////
    
    init() {
        serviceWorker = PixabayServiceWorker()
    }
    

    // MARK: - Fetching methods
    // //////////////////////////////////////////////////////////////////////////

    func fetchData(completion: @escaping (NetworkError?)->()) {
        let dispatchGroup = DispatchGroup()

        categories.forEach { [weak self] category in
            dispatchGroup.enter()

            serviceWorker?.getTopPopularPicturesFrom(category: category) { response in
                DispatchQueue.main.async {
                    switch response {
                    case .success(let data):
                        self?.createCollection(withData: data.items, andCategory: category)
                    case .failure(let error):
                        completion(error)
                    }
                    
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
    
    func fetchDataFromFiles(completion: @escaping (NetworkError?)->()) {
        categories.forEach { [weak self] category in
            guard let items = self?.serializeJsonCollection(category.rawValue) else { return }
            self?.createCollection(withData: items, andCategory: category)
        }
        completion(nil)
    }
    
    private func serializeJsonCollection(_ name: String) -> [PixabayImageItem]? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: url)
            do {
                let items = try jsonDecoder.decode([PixabayImageItem].self, from: data)
                return items
            } catch {
                print("failed to convert data")
            }
        } catch let error {
            print(error)
        }
        return nil
    }
    
    private func createCollection(withData data: [PixabayImageItem], andCategory category: ApiParameters.Category) {
        let tenMostViewedPictures = findMostViewedPictures(items: data)
        let collection = PictureCollection(name: category.rawValue.capitalized,
                                           items: tenMostViewedPictures)
        collections.append(collection)
        
        DataManager.shared.updateDataBase(withObjects: tenMostViewedPictures)
        print(collection.name, collection.items.count)   //// to remove
    }
    
    private func findMostViewedPictures(items: [PixabayImageItem]) -> [PixabayImageItem] {
        let sortedArray = items.sorted { $0.views > $1.views }
        return Array(sortedArray.prefix(Constants.topViewedPhotosNumber))
    }

    
    // MARK: - Images preview methods
    // //////////////////////////////////////////////////////////////////////////
    
    func downloadCollectionImages(completion: @escaping (NetworkError?)->()) {
        let allImages = collections.flatMap { $0.items }

        let dispatchGroup = DispatchGroup()

        allImages.forEach { [weak self] item in
            guard let self = self else { return }
            dispatchGroup.enter()

            serviceWorker?.downloadImage(url: item.largeImageURL) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let image):
                        
                        //let imageData = image.jpegData(compressionQuality: 0.9)
                        //let pixabayImage = PixaBayImage(imageId: item.id, previewSizeImageData: imageData)
                        //DataManager.shared.addObject(object: pixabayImage)
                        ImageCacheService.shared.cache(object: image, forKey: item.id)
                        
                    case .failure(let error):
                        DispatchQueue.main.async { completion(error) }
                    }
                    
                    self.progress += self.progressStep
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) { completion(nil) }
    }
}
