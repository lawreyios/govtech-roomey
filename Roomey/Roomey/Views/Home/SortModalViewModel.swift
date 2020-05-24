//
//  SortModalViewModel.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

class SortModalViewModel {
    
    var selectedSortType = SortType.level
    
    func applySortType(_ sortType: SortType) -> SortType  {
        selectedSortType = sortType
        return selectedSortType
    }
    
    func resetSortType() -> SortType {
        selectedSortType = .level
        return selectedSortType
    }
    
}
