//
//  ProviderProtocol.swift
//

import Foundation

protocol ProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
    func request(service: ServiceProtocol, completion: @escaping (Bool) -> Void)
    func uploadImage<T>(type: T.Type, service: ServiceProtocol, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
}
