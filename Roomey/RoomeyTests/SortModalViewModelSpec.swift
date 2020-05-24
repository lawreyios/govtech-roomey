//
//  SortModalViewModelSpec.swift
//  RoomeyTests
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import Quick
import Nimble

@testable import Roomey

class SortModalViewModelSpec: QuickSpec {
    
    override func spec() {
        let viewModel = SortModalViewModel()
        
        describe("Given user opens up sort sheet") {
            context("When user applies level sorting") {
                beforeEach {
                    _ = viewModel.applySortType(.level)
                }
                
                it("Then it should apply the appropriate sort") {
                    expect(viewModel.selectedSortType).to(equal(.level))
                }
            }
            
            context("When user applies capacity sorting") {
                beforeEach {
                    _ = viewModel.applySortType(.capacity)
                }
                
                it("Then it should apply the appropriate sort") {
                    expect(viewModel.selectedSortType).to(equal(.capacity))
                }
            }
            
            context("When user applies availability sorting") {
                beforeEach {
                    _ = viewModel.applySortType(.availability)
                }
                
                it("Then it should apply the appropriate sort") {
                    expect(viewModel.selectedSortType).to(equal(.availability))
                }
            }
            
            context("When user resets sorting") {
                beforeEach {
                    _ = viewModel.resetSortType()
                }
                
                it("Then it should apply the level sort") {
                    expect(viewModel.selectedSortType).to(equal(.level))
                }
            }
        }
    }
    
}
