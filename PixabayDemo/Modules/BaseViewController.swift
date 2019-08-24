//
//  BaseViewController.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func showLoader() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .blue
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
        }
    }
    
    func showLoaderError(withMessage message: String) {
        view.backgroundColor = .red
        showAlert(withMessage: message)
    }
    
    private func showAlert(withMessage message: String) {
        let alerController = UIAlertController(title: "Networking problem!", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.hideLoader()
        }
        alerController.addAction(okAction)
        present(alerController, animated: true)
    }
}
