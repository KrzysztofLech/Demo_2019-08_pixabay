//
//  PixabayServiceWorker.swift
//  PixabayDemo
//
//  Created by Krzysztof Lech on 24/08/2019.
//  Copyright © 2019 Krzysztof Lech. All rights reserved.
//

import Foundation

protocol PixabayServiceWorkerProtocol: AnyObject {
    func getPictureListWith(searchTerm text: String, completion: @escaping (Result<PixabayImageSearchResult, NetworkError>) -> Void)
    func getTopPopularPicturesFrom(category: ApiParameters.Category, completion: @escaping (Result<PixabayImageSearchResult, NetworkError>) -> Void)
}

final class PixabayServiceWorker: PixabayServiceWorkerProtocol {
    
    private let provider: ProviderProtocol
    
    init(provider: ProviderProtocol = URLSessionProvider()) {
        self.provider = provider
    }
    
    func getPictureListWith(searchTerm text: String, completion: @escaping (Result<PixabayImageSearchResult, NetworkError>) -> Void) {
        let service = PixabayService.getPictureListWith(searchTerm: text)
        provider.request(type: PixabayImageSearchResult.self, service: service, completion: completion)
    }
    
    func getTopPopularPicturesFrom(category: ApiParameters.Category, completion: @escaping (Result<PixabayImageSearchResult, NetworkError>) -> Void) {
        let service = PixabayService.getTopPopularPictures(category: category)
        provider.request(type: PixabayImageSearchResult.self, service: service, completion: completion)
    }
}
