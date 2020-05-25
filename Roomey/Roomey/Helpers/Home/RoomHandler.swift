//
//  RoomHandler.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Alamofire

class RoomAvailabilityHandler: APIHandler {
    
    @Published var networkError = NetworkError.none
    @Published var isLoading = false
    @Published var rooms = [Room]()
    
    func getRooms() {
        
        isLoading = true
        
        AF.request(NetworkService.appEnvironment.roomAvailabilityURL, method: .get, encoding: URLEncoding.default).responseDecodable { [weak self] (response: DataResponse<[Room], AFError>) in
            
            guard let weakSelf = self else { return }
            
            guard let rooms = weakSelf.handleResponse(response).response as? [Room] else {
                weakSelf.isLoading = false
                debugPrint("Error Loading Data!")
                return
            }
            
            weakSelf.isLoading = false
            weakSelf.rooms = rooms.sorted { Int($0.level) ?? .zero < Int($1.level) ?? .zero }
        }
        
    }
    
}
