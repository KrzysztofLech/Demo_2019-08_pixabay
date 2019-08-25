//
//  SplashScreenViewController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 25/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class SplashScreenViewController: BaseViewController {
    
    private enum Constants {
        static let collectionScreenIdentifier = "CollectionScreen"
    }
    
    @IBOutlet private var button: UIButton!
    private let controller = SplashScreenController()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchData()
    }
    
    private func fetchData() {
        showLoader()
        controller.fetchData(progressHandler: { [weak self] progress in
            switch progress {
            case .error(let error):
                self?.hideLoader()
                self?.showLoaderError(withMessage: error.message)
                
            case .progress(let progressValue):
                print("Progress: ", progressValue)
                
            case .finish:
                self?.hideLoader()
                self?.showCollectionScreen()
                print("Finish!")
            }
        })
    }
    
    private func showCollectionScreen() {
        performSegue(withIdentifier: Constants.collectionScreenIdentifier, sender: nil)
    }
}
