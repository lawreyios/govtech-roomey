//
//  RoomAvailability.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

enum Timeslot: Int {
    case notAvailable
    case available
}

class Room: Identifiable, Decodable {
    
    var name = String.empty
    var capacity = String.empty
    var level = String.empty
    var availability = [String: String]()
    var isAvailable = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case capacity
        case level
        case availability
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = (try? container.decode(String.self, forKey: .name)) ?? .empty
        capacity = (try? container.decode(String.self, forKey: .capacity)) ?? .empty
        level = (try? container.decode(String.self, forKey: .level)) ?? .empty
        availability = (try? container.decode([String: String].self, forKey: .availability)) ?? [String: String]()
    }
    
}

