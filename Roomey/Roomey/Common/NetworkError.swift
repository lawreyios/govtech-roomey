//
//  NetworkError.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case generic
    case none
}

extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .generic: return "Something went wrong, please try again later."
        case .none: return nil
        }
    }
}
