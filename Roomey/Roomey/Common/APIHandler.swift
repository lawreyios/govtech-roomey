//
//  APIHandler.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Alamofire
import Combine

enum HTTPStatusCode: Int {
    case ok = 200
    case noContent = 204
    case badRequest = 400
    case invalidClientKey = 401
    case unauthorized = 403
    case internalServerError = 500
    
    var getStatusMessage: String {
        switch self {
        case .ok:
            return "Success"
        case .noContent:
            return "Content Not Updated"
        case .badRequest:
            return "Bad Request"
        case .invalidClientKey:
            return "Unauthorized"
        case .unauthorized:
            return "Unauthorized"
        case .internalServerError:
            return "Internal Server Error"
        }
    }
}

typealias APIResponse = (response: Any?, networkError: NetworkError)

class APIHandler: ObservableObject {
        
    var statusCode = Int.zero
    
    func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>) -> APIResponse {
        statusCode = response.response?.statusCode ?? .zero
        
        switch response.result {
        case .success:
            if statusCode != HTTPStatusCode.ok.rawValue {
                return (response: nil, networkError: .generic)
            }
            
            guard let response = response.value else {
                return (response: nil, networkError: .generic)
            }
            
            return (response: response, networkError: .none)
        case .failure:
                        
            if let httpStatusCode = response.response?.statusCode {
                let _ = HTTPStatusCode(rawValue: httpStatusCode)?.getStatusMessage ?? .empty
                
                return (response: nil, networkError: .generic)
            }
            
            if response.error?.localizedDescription != nil {
                return (response: nil, networkError: .generic)
            }
        }
        
        return (response: nil, networkError: .generic)
    }
  
}

