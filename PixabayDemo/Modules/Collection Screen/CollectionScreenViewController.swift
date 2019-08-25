//
//  CollectionScreenViewController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class CollectionScreenViewController: BaseViewController {

    private var serviceWorker: PixabayServiceWorkerProtocol?
    private var pixabayImageItems: [PixabayImageItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serviceWorker = PixabayServiceWorker()
        
        getPictureListWith(searchTerm: "greece+sea") { [weak self] networkError in
            guard let self = self else { return }
            
            if let error = networkError {
                self.showLoaderError(withMessage: error.message)
            } else {
                self.hideLoader()
                self.printItemData()
            }
        }
    }
    
    private func getPictureListWith(searchTerm text: String, completion: @escaping (NetworkError?)->() ) {
        serviceWorker?.getPictureListWith(searchTerm: text, completion: { [weak self] response in
            switch response {
            case let .success(data):
                self?.pixabayImageItems = data.items
                DispatchQueue.main.async { completion(nil) }
                
            case let .failure(error):
                DispatchQueue.main.async { completion(error) }
            }
        })
    }
    
    private func printItemData() {
        print(self.pixabayImageItems.count)
        pixabayImageItems.forEach {
            print($0.user)
        }
    }
}
