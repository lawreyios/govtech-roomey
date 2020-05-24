//
//  RoomListViewModel.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI
import Combine

class RoomListViewModel: ObservableObject {
    
    @Published var date = String.empty {
        didSet { isFormValidated = !date.isEmpty && !time.isEmpty }
    }
    
    @Published var time = String.empty {
        didSet { isFormValidated = !date.isEmpty && !time.isEmpty }
    }
    
    @Published var isFormValidated = false
    @Published var isLoading = false
    var rooms = [Room]() { didSet { filterRooms() }}
    var availableRooms = [Room]()
    @Published var updatedRooms = [Room]()
    @Published var selectedSortType = SortType.level
    
    private var disposables: Set<AnyCancellable> = []
    private var roomAvailabilityHandler = RoomAvailabilityHandler()
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        roomAvailabilityHandler.$isLoading
            .receive(on: RunLoop.main)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    private var roomsPublisher: AnyPublisher<[Room], Never> {
        roomAvailabilityHandler.$rooms
            .receive(on: RunLoop.main)
            .map { rooms in
                return rooms
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposables)
        
        roomsPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.rooms, on: self)
            .store(in: &disposables)
    }
    
    func getRooms() {
        roomAvailabilityHandler.getRooms()
    }
    
    func filterRooms() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateTimeFormat.timeWithAMPM
        
        if let selectedTime = dateFormatter.date(from: time) {
            dateFormatter.dateFormat = DateTimeFormat.timeInHours
            let selectedDateInHours = dateFormatter.string(from: selectedTime)
                        
            availableRooms = rooms.filter { room in
                !room.availability.filter { timeslot in
                    timeslot.key == selectedDateInHours
                        && Timeslot(rawValue: Int(timeslot.value) ?? .zero) == .available
                }.isEmpty
            }
            
            updateRoomAvailability()
        }
    }
    
    func updateRoomAvailability() {
        updatedRooms = rooms.map { room in
            let updatedRoom = room
            updatedRoom.isAvailable = !availableRooms.filter { $0.name == room.name }.isEmpty
            return updatedRoom
        }
    }
    
    func applySort() {
        switch selectedSortType {
        case .level: updatedRooms.sort { Int($0.level) ?? .zero < Int($1.level) ?? .zero }
        case .capacity: updatedRooms.sort { Int($0.capacity) ?? .zero < Int($1.capacity) ?? .zero }
        case .availability: updatedRooms.sort { $0.isAvailable && !$1.isAvailable }
        }
    }
    
}