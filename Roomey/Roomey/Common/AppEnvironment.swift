//
//  AppEnvironment.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Foundation

fileprivate let environmentKey = "Application Environment"

struct NetworkService {
    
    static var appEnvironment: AppEnvironment = {
        let environment = Bundle.main.object(forInfoDictionaryKey: environmentKey) as? String ?? .empty
        return AppEnvironment(rawValue: environment) ?? AppEnvironment.none
    }()
    
}

enum AppEnvironment: String {
    case dev = "dev"
    case qa = "qa"
    case uat = "uat"
    case prod = "prod"
    case none = ""
    
    private var baseURL: String {
        switch self {
        case .dev:
            return "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6"
        case .qa:
            return "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6"
        case .uat:
            return "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6"
        case .prod:
            return "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6"
        case .none:
            return "https://gist.githubusercontent.com/yuhong90/7ff8d4ebad6f759fcc10cc6abdda85cf/raw/463627e7d2c7ac31070ef409d29ed3439f7406f6"
        }
    }
    
    var roomAvailabilityURL: String { return baseURL + "/room-availability.json" }
}
