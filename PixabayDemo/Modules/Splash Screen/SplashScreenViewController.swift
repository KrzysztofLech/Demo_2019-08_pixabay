//
//  SplashScreenViewController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class SplashScreenViewController: BaseViewController {
    
    private enum Constants {
        static let collectionScreenIdentifier = "CollectionScreen"
    }
    
    @IBOutlet private var downloadingProgressView: DownloadingProgressView!
    
    private let controller = SplashScreenController()

    // MARK: - Lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controller.delegate = downloadingProgressView
        fetchData()
    }
    
    // MARK: - Fetching methods
    
    private func fetchData() {
        showLoader()
        controller.fetchData { [weak self] error in
            if let errorMessage = error?.message {
                DispatchQueue.main.async { self?.showLoaderError(withMessage: errorMessage) }
            } else {
                print("Data downloaded!")       ///
                self?.downloadImages()
                //self?.showCollectionScreen()
            }
        }
    }

    // MARK: - Images downloading methods

    private func downloadImages() {        
        controller.downloadCollectionImages { [weak self] error in
            if let errorMessage = error?.message {
                DispatchQueue.main.async { self?.showLoaderError(withMessage: errorMessage) }
            } else {
                print("Images downloaded!")     ///
                self?.hideLoader()
                self?.showCollectionScreen()
            }
        }
    }
    
    // MARK: - Navigation methods
    
    private func showCollectionScreen() {
        let storyboard = UIStoryboard(name: Constants.collectionScreenIdentifier, bundle: nil)
        
        guard
            let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController,
            let viewController = navigationController.topViewController as? CollectionScreenViewController
            else { return }
        
        viewController.collections = controller.collections
        present(navigationController, animated: true)
    }
}
