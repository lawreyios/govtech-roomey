//
//  RoomCardView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/23/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

struct RoomCardView: View {
    
    var room: Room
    
    var body: some View {
        ZStack {
            HStack {
                VStack {
                    Text(room.name).fontWeight(.bold)
                    Text("\(RoomAvailabilityCard.levelText) \(room.level)")
                }
                Spacer()
                Spacer()
                VStack {
                    Text(room.isAvailable
                        ? RoomAvailabilityCard.availableText
                        : RoomAvailabilityCard.notAvailableText).fontWeight(.light)
                    Text("\(room.capacity) \(RoomAvailabilityCard.paxText)")
                }
            }
        }.padding(14.0)
    }
    
}
