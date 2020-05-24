//
//  SortModalView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

enum SortType: Int {
    case capacity
    case availability
    case level
    
    var title: String {
        switch self {
        case .capacity: return "Capacity"
        case .availability: return "Availability"
        case .level: return "Level"
        }
    }
}

struct SortRow: View {
    
    @Binding var selectedSortType: SortType
    var sortType: SortType
    
    var body: some View {
        HStack {
            Text(sortType.title)
            Spacer()
            if selectedSortType == sortType {
                Image(Icon.checkmark)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18.0, height: 16.0)
            }
        }.contentShape(Rectangle())
    }
    
}

struct SortModalView: View {
    
    @Binding var shouldPresentSortView: Bool
    @Binding var selectedSortType: SortType
    
    var viewModel = SortModalViewModel()
    
    @State var currentSortType = SortType.level
    
    init(shouldPresentSortView: Binding<Bool>, selectedSortType: Binding<SortType>) {
        _shouldPresentSortView = shouldPresentSortView
        _selectedSortType = selectedSortType
    }
    
    var footerView: some View {
        HStack {
            Button(action: {
                self.selectedSortType = self.viewModel.resetSortType()
                self.shouldPresentSortView = false
            }) {
                Text("Reset")
            }.layoutPriority(.zero)
            Spacer()
            Button(action: {
                self.selectedSortType = self.viewModel.applySortType(self.currentSortType)
                self.shouldPresentSortView = false
            }) {
                Text("Apply")
            }.layoutPriority(1.0)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section {
                        SortRow(selectedSortType: self.$currentSortType, sortType: .level).onTapGesture {
                            self.currentSortType = .level
                        }
                        SortRow(selectedSortType: self.$currentSortType, sortType: .capacity).onTapGesture {
                            self.currentSortType = .capacity
                        }
                        SortRow(selectedSortType: self.$currentSortType, sortType: .availability).onTapGesture {
                            self.currentSortType = .availability
                        }
                    }
                }
                Spacer()
                Spacer()
                footerView
            }
            .padding(12.0)
            .navigationBarTitle(Text(PageTitle.sort), displayMode: .inline)
            .onAppear {
                self.currentSortType = self.selectedSortType
            }
        }
    }
    
}
