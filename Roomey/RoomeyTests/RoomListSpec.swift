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
                    expect(viewModel.updatedRooms.first!.level).to(equal("7"))
                    expect(viewModel.updatedRooms.middle!.level).to(equal("8"))
                    expect(viewModel.updatedRooms.last!.level).to(equal("9"))
                }
                
                it("And room details displayed must include Room name, location, capacity and respective availability") {
                    expect(viewModel.updatedRooms.first!.name).to(equal("Kopi-O"))
                    expect(viewModel.updatedRooms.first!.level).to(equal("7"))
                    expect(viewModel.updatedRooms.first!.capacity).to(equal("8"))
                    expect(viewModel.updatedRooms.first!.isAvailable).to(equal(false))
                }
                
                it("should filter the available rooms based on selected time") {
                    expect(viewModel.availableRooms.count).to(equal(5))
                }
                
                it("should update availability of room accordingly") {
                    expect(viewModel.updatedRooms.first!.isAvailable).to(equal(false))
                    expect(viewModel.updatedRooms.last!.isAvailable).to(equal(true))
                }
            }
        }
        
        describe("Given user is on Room Listing Page") {
            beforeEach {
                viewModel.date = "23 May 2020"
                viewModel.time = "1:00 PM"
                                
                viewModel.rooms = ResponseDataFactory.getRoomsDataFromJSON()!
                viewModel.filterRooms()
            }
            
            context("When clicked on sort button and apply level sorting") {
                beforeEach {
                    viewModel.selectedSortType = .level
                    viewModel.applySort()
                }
                
                it("Then user should be able to see the sorted list") {
                    expect(viewModel.updatedRooms.first!.name).to(equal("Kopi-O"))
                    expect(viewModel.updatedRooms.first!.level).to(equal("7"))
                    expect(viewModel.updatedRooms.middle!.name).to(equal("Rojak"))
                    expect(viewModel.updatedRooms.middle!.level).to(equal("8"))
                    expect(viewModel.updatedRooms.last!.name).to(equal("Grassland"))
                    expect(viewModel.updatedRooms.last!.level).to(equal("9"))
                }
            }
            
            context("When clicked on sort button and apply capacity sorting") {
                beforeEach {
                    viewModel.selectedSortType = .capacity
                    viewModel.applySort()
                }
                
                it("Then user should be able to see the sorted list") {
                    expect(viewModel.updatedRooms.first!.name).to(equal("Sky"))
                    expect(viewModel.updatedRooms.first!.capacity).to(equal("2"))
                    expect(viewModel.updatedRooms.middle!.name).to(equal("Teh-Halia"))
                    expect(viewModel.updatedRooms.middle!.capacity).to(equal("4"))
                    expect(viewModel.updatedRooms.last!.name).to(equal("Rojak"))
                    expect(viewModel.updatedRooms.last!.capacity).to(equal("14"))
                }
            }
            
            context("When clicked on sort button and apply availability sorting") {
                beforeEach {
                    viewModel.selectedSortType = .availability
                    viewModel.applySort()
                }
                
                it("Then user should be able to see the sorted list") {
                    expect(viewModel.updatedRooms.first!.name).to(equal("Sky"))
                    expect(viewModel.updatedRooms.first!.isAvailable).to(beTrue())
                    expect(viewModel.updatedRooms.middle!.name).to(equal("Milo"))
                    expect(viewModel.updatedRooms.middle!.isAvailable).to(beFalse())
                    expect(viewModel.updatedRooms.last!.name).to(equal("Mee-Siam"))
                    expect(viewModel.updatedRooms.last!.isAvailable).to(beFalse())
                }
            }

        }
    }
    
}
