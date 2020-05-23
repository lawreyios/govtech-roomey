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
    @Published var rooms = [Room]() { didSet { filterRooms() }}
    @Published var availableRooms = [Room]()
    
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
        availableRooms.removeAll()
        
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
        }
    }
    
    func isRoomAvailableFor(_ room: Room) -> Bool {
        return !availableRooms.filter { $0.name == room.name }.isEmpty
    }
    
}
