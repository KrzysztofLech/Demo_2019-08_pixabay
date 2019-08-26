//
//  ServiceProtocol.swift
//

import Foundation

typealias Headers = [HeaderKey: String]

protocol ServiceProtocol {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: NetworkTask { get }
    var headers: Headers? { get }
    var parametersEncoding: ParametersEncoding { get }
}
