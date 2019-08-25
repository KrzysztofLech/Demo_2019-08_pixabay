//
//  ProviderProtocol.swift
//

import UIKit

protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
    func request(service: ServiceProtocol, completion: @escaping (Bool) -> Void)
    func downloadImage(url: String, completion: @escaping (Result<UIImage?, NetworkError>) -> Void)
    func uploadImage<T>(type: T.Type, service: ServiceProtocol, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
}
