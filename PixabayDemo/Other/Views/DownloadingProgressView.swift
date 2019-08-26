//
//  DownloadingProgressView.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 26/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class DownloadingProgressView: UIView {
    
    @IBOutlet private var progressView: UIProgressView!
}

extension DownloadingProgressView: ProgressViewDelegate {
    func progressChanged(currentProgress: Float) {
        progressView.setProgress(currentProgress, animated: true)
    }
}
