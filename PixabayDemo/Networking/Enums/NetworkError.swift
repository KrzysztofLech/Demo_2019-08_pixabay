//
//  NetworkError.swift
//


enum NetworkError: Error {
    case unknown(Error?)
    case noJSONData
    case parseJSON(Error)
    
    var message: String {
        switch self {
        case .noJSONData:
            return "No JSON Data!"
            
        case let .unknown(error):
            return error?.localizedDescription ?? "Unknown error!"
            
        case let .parseJSON(error):
            print("Parse JSON error: ", error.localizedDescription)
            return "Data parsing error!"
        }
    }
}
