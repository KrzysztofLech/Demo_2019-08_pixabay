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
        static let delayBeforePreseningCollections = 1.0
    }
    
    @IBOutlet private var progressView: DownloadingManagerView!
    
    private let controller = SplashScreenController()

    // MARK: - Lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controller.delegate = self
        progressView.startAnimation()
        fetchData()
    }
    
    // MARK: - Fetching methods
    
    private func fetchData() {
        progressView.changeStage(.downloadingData)
        controller.fetchData { [weak self] error in
            if let errorMessage = error?.message {
                DispatchQueue.main.async { self?.showLoaderError(withMessage: errorMessage) }
            } else {
                self?.downloadImages()
            }
        }
    }

    // MARK: - Images downloading methods

    private func downloadImages() {
        progressView.changeStage(.downloadingImages)
        controller.downloadCollectionImages { [weak self] error in
            if let errorMessage = error?.message {
                DispatchQueue.main.async { self?.showLoaderError(withMessage: errorMessage) }
            } else {
                self?.showFinishMessageAndPresentCollectionController()
            }
        }
    }
    
    private func showFinishMessageAndPresentCollectionController() {
        progressView.changeStage(.done)
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.delayBeforePreseningCollections) { [weak self] in
            self?.showCollectionScreen()
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

// MARK: - ProgressViewDelegate method

extension SplashScreenViewController: ProgressViewDelegate {
    func progressChanged(currentProgress: Float, downloadedImage: UIImage?) {
        DispatchQueue.main.async {
            self.progressView.changeProgressValue(currentProgress, image: downloadedImage)
        }
    }
}
