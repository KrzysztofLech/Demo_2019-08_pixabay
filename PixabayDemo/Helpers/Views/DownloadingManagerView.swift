//
//  DownloadingManagerView.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 05/10/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

final class DownloadingManagerView: UIView {
    
    private enum Constants {
        static let animationDuration = 0.2
    }
    
    @IBOutlet private var progressIndicatorView: DownloadingProgressView!
    @IBOutlet private var progressLabel: UILabel!
    @IBOutlet private var progressImageView: UIView!
    
    private var downloadingStage: DownloadingStage = .none
    private var downloadedImages: [UIImageView] = []
        
    // MARK: - Init methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        changeStage(.none)
        progressImageView.backgroundColor = .clear
    }
        
    // MARK: - Other methods
    
    func changeStage(_ state: DownloadingStage) {
        downloadingStage = state
        
        setupProgressLabel()
                
        if downloadingStage == .done {
            progressIndicatorView.progressValue = 1.0
        }
    }
    
    private func setupProgressLabel() {
        progressLabel.alpha = 0.0
        progressLabel.text = downloadingStage.message

        UIView.animate(withDuration: 0.3) {
            self.progressLabel.alpha = 1.0
        }
    }
    
    func startAnimation() {
        progressIndicatorView.startAnimation()
    }
    
    func changeProgressValue(_ value: Float, image: UIImage?) {
        progressIndicatorView.progressValue = value
        if value > 0.9 {
            progressLabel.text = downloadingStage.almostDoneMessage
        }
        
        handleImages(downloadedImage: image)
    }
    
    private func handleImages(downloadedImage: UIImage?) {
        guard let image = downloadedImage else { return }
        
        hidePreviousImage()
        showNewImage(image)
    }
    
    private func showNewImage(_ image: UIImage) {
        let aspectRatio = image.size.width / image.size.height
        let parentRect = progressImageView.bounds
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: parentRect.width,
                                 y: 0,
                                 width: parentRect.height * aspectRatio,
                                 height: parentRect.height)

        progressImageView.addSubview(imageView)
        downloadedImages.append(imageView)
        
        let translationToCenter = -(progressImageView.bounds.width + imageView.bounds.width) / 2
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        imageView.transform = CGAffineTransform(translationX: translationToCenter, y: 0)
        })
    }
    
    private func hidePreviousImage() {
        guard let previousImageView = downloadedImages.last else { return }

        let translationToOutside = -(progressImageView.bounds.width + previousImageView.bounds.width)
        UIView.animate(withDuration: Constants.animationDuration,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        previousImageView.transform = CGAffineTransform(translationX: translationToOutside, y: 0)
        }) { _ in
            previousImageView.image = nil
            previousImageView.removeFromSuperview()
        }
    }
}
