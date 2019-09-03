//
//  ImageDownloadOperation.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 01/09/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import UIKit

class ImageDownloadOperation: Operation {
    
    private var task: URLSessionDataTask?
    
    enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    private var state: OperationState = .ready {
        willSet {
            willChangeValue(forKey: "isExecuting")
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isExecuting")
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(url: String, completionHandler: @escaping ((UIImage?) -> Void) ) {
        super.init()
        
        guard let taskURL = URL(string: url) else { return }
        task = URLSession.shared.dataTask(with: taskURL, completionHandler: { [weak self] (data, response, error) in
            if error == nil, let data = data, let image = UIImage(data: data) {
                completionHandler(image)
            } else {
                completionHandler(nil)
            }
            
            self?.state = .finished
        })
    }
    
    override func start() {
        if(isCancelled) {
            state = .finished
            return
        }
        
        state = .executing
        task?.resume()
        print("... downloading :", task?.originalRequest?.url?.absoluteString ?? "")
    }
    
    override func cancel() {
        super.cancel()
        
        task?.cancel()
    }
}

