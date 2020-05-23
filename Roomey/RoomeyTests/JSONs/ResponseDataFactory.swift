//
//  ResponseDataFactory.swift
//  RoomeyTests
//
//  Created by Lawrence Tan on 5/23/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Foundation

@testable import Roomey

class ResponseDataFactory {
    
    static func responseData(filename: String) -> Data {
        guard let path = Bundle(for: ResponseDataFactory.self)
            .path(forResource: filename, ofType: "json"),
            let data = try? NSData.init(contentsOfFile: path, options: []) else {
                fatalError("\(filename).json not found")
        }
        return data as Data
    }
    
    static func getRoomsDataFromJSON() -> [Room]? {
        do {
            let data = responseData(filename: "room-availability")
            return try? JSONDecoder().decode([Room].self, from: data)
        }
    }
    
}

