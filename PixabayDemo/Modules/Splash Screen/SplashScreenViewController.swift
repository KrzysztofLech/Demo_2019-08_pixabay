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
    
    @IBOutlet private var button: UIButton!
    @IBOutlet var progressView: UIProgressView!
    
    private let controller = SplashScreenController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controller.delegate = self
        fetchData()
    }
    
    private func fetchData() {
        showLoader()
        controller.fetchData { [weak self] error in
            if let errorMessage = error?.message {
                self?.showLoaderError(withMessage: errorMessage)
            } else {
                print("Data downloaded!")       ///
                self?.downloadImages()
            }
        }
    }
    
    private func downloadImages() {
        controller.downloadCollectionImages { [weak self] error in
            if let errorMessage = error?.message {
                self?.showLoaderError(withMessage: errorMessage)
            } else {
                print("Images downloaded!")     ///
                self?.showCollectionScreen()
            }
        }
    }
    
    private func showCollectionScreen() {
        print("images: ", controller.images.count)
        hideLoader()
        performSegue(withIdentifier: Constants.collectionScreenIdentifier, sender: nil)
    }
}

extension SplashScreenViewController: ProgressViewDelegate {
    func progressChanged(currentProgress: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.setProgress(currentProgress, animated: true)
        }
    }
}
