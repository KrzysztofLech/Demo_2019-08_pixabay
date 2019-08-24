//
//  URLSessionProvider.swift
//

import UIKit

final class URLSessionProvider: ProviderProtocol {
    
    private enum Constants {
        static let errorDescription = "cancelled"
    }
    
    private var session: URLSessionProtocol
    private var previousTask: URLSessionDataTask?
    private var previousService: ServiceProtocol?

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func request(service: ServiceProtocol, completion: @escaping (Bool) -> Void) {
        let request = URLRequest(service: service)
        let task = session.dataTask(request: request, completionHandler: { [weak self] _, response, error in
            guard error?.localizedDescription != Constants.errorDescription else { return }
            let httpResponse = response as? HTTPURLResponse
            self?.handleResponseStatus(response: httpResponse, error: error, completion: completion)
        })
        
        if previousService?.path == service.path { previousTask?.cancel() }
        
        task.resume()
        
        previousTask = task
        previousService = service
    }

    func request<T>(type _: T.Type, service: ServiceProtocol, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        let request = URLRequest(service: service)
        let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            guard error?.localizedDescription != Constants.errorDescription else { return }
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        
        if previousService?.path == service.path { previousTask?.cancel() }
        
        task.resume()
        
        previousTask = task
        previousService = service
    }

    func imageRequest(service: ServiceProtocol, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(service: service)
        let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleResponseStatus(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
    }

    func uploadImage<T>(type _: T.Type, service: ServiceProtocol, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard case let NetworkTask.upload(bodyData) = service.task else { return }

        let request = URLRequest(service: service)
        let task = session.uploadTask(request: request, data: bodyData) { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        }
        task.resume()
    }

    private func handleResponseStatus(response: HTTPURLResponse?, error: Error?, completion: (Bool) -> Void) {
        guard error == nil else { return completion(false) }
        guard let response = response else { return completion(false) }
        switch response.statusCode {
        case 200 ... 299:
            completion(true)
        default:
            completion(false)
        }
    }

    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (Result<T, NetworkError>) -> Void) {
        guard error == nil else { return completion(.failure(.unknown(error!))) }
        guard let response = response else { return completion(.failure(.noJSONData)) }
        switch response.statusCode {
        case 200 ... 299:
            guard let data = data else { return completion(.failure(.noJSONData)) }
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.parseJSON(error)))
            }
        default:
            completion(.failure(.unknown(nil)))
        }
    }

    private func handleResponseStatus(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (UIImage?) -> Void) {
        guard error == nil else { return completion(nil) }
        guard let response = response else { return completion(nil) }
        switch response.statusCode {
        case 200 ... 299:
            guard let data = data else { return completion(nil) }
            let image = UIImage(data: data)
            completion(image)
        default:
            completion(nil)
        }
    }
}
