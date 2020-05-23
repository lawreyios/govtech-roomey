//
//  RoomListSpec.swift
//  RoomListSpec
//
//  Created by Lawrence Tan on 5/23/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Quick
import Nimble
import Combine

@testable import Roomey

class RoomListSpec: QuickSpec {
    
    override func spec() {
        let viewModel = RoomListViewModel()
        
        describe("Given user has selected date & time") {
            beforeEach {
                viewModel.date = "23 May 2020"
                viewModel.time = "1:00 PM"
                                
                viewModel.rooms = ResponseDataFactory.getRoomsDataFromJSON()!
                viewModel.filterRooms()
            }
            
            context("When network connection is available") {
                it("Then room listing should be displayed, sorted by level in ascending order by default") {
                    expect(viewModel.rooms.first!.level).to(equal("7"))
                    expect(viewModel.rooms[viewModel.rooms.count/2].level).to(equal("8"))
                    expect(viewModel.rooms.last!.level).to(equal("9"))
                }
                
                it("should filter the available rooms based on selected time") {
                    expect(viewModel.availableRooms.count).to(equal(5))
                }
                
                it("should update availability of room accordingly") {
                    expect(viewModel.isRoomAvailableFor(viewModel.rooms.first!)).to(equal(false))
                    expect(viewModel.isRoomAvailableFor(viewModel.rooms.last!)).to(equal(true))
                }
            }
        }
    }
    
}
