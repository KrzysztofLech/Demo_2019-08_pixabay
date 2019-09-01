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
    // //////////////////////////////////////////////////////////////////////////
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        controller.delegate = downloadingProgressView
        //fetchData()
        fetchDataFromFiles()
        //showCollectionScreen()
        
//        let serializer = JSONSerializer()
//        serializer.serialize(input: "greece")
    }
    
    // MARK: - Fetching methods
    // //////////////////////////////////////////////////////////////////////////
    
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
    
    private func fetchDataFromFiles() {
        showLoader()
        controller.fetchDataFromFiles { [weak self] error in
            if let errorMessage = error?.message {
                self?.showLoaderError(withMessage: errorMessage)
            } else {
                print("Data was read correctly!")       ///
                self?.downloadImages()
            }
        }
    }

    
    // MARK: - Images downloading methods
    // //////////////////////////////////////////////////////////////////////////

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

    
    // MARK: - Navigation methods
    // //////////////////////////////////////////////////////////////////////////
    
    private func showCollectionScreen() {
        hideLoader()
        performSegue(withIdentifier: Constants.collectionScreenIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? CollectionScreenViewController
            else { return }
        
        viewController.collections = controller.collections
    }
}
