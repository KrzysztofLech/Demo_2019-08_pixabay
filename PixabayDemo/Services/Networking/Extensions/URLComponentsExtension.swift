//
//  URLComponentsExtension.swift
//

import Foundation

extension URLComponents {
    
    init(service: ServiceProtocol) {
        let url = service.baseURL.appendingPathComponent(service.path)
        self.init(url: url, resolvingAgainstBaseURL: false)!

        guard case let .requestParameters(parameters) = service.task, service.parametersEncoding == .url else { return }

        queryItems = parameters.map { key, value in
            URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
