//
//  URLSessionProtocol.swift
//

import Foundation

protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
    func uploadTask(request: URLRequest, data: Data, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {
    func dataTask(request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return dataTask(with: request, completionHandler: completionHandler)
    }

    func uploadTask(request: URLRequest, data: Data, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        return uploadTask(with: request, from: data, completionHandler: completionHandler)
    }
}
