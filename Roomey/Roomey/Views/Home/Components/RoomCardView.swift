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
                VStack(alignment: .leading) {
                    Text(room.name)
                        .modifier(FontModifier(appFont: .medium, size: 16.0, color: Color.appColor(.charcoal)))
                    Text("\(RoomAvailabilityCard.levelText) \(room.level)")
                        .modifier(FontModifier(appFont: .regular, size: 14.0, color: Color.appColor(.charcoal)))
                        .padding(.top, 8.0)
                }
                Spacer()
                Spacer()
                VStack(alignment: .trailing) {
                    Text(room.isAvailable
                        ? RoomAvailabilityCard.availableText
                        : RoomAvailabilityCard.notAvailableText)
                        .modifier(FontModifier(appFont: .lightItalic, size: 16.0, color: Color.appColor(room.isAvailable ? .chateauGreen : .starDust)))
                    Text("\(room.capacity) \(RoomAvailabilityCard.paxText)")
                        .modifier(FontModifier(appFont: .regular, size: 14.0, color: Color.appColor(.charcoal)))
                        .padding(.top, 8.0)
                }
            }
            .padding(.vertical, 14.0)
            .padding(.horizontal, 28.0)
        }
        .background(Color.appColor(.whiteSmoke))
        .cornerRadius(8.0, corners: .allCorners)
    }
    
}
