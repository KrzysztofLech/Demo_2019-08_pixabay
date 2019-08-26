//
//  NetworkTask.swift
//

import Foundation

typealias NetworkParameters = [String: Any]

enum NetworkTask {
    case requestPlain
    case requestParameters(NetworkParameters)
    case upload(Data)
}
