//
//  RoomListView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    
    @ObservedObject var viewModel = RoomListViewModel()
    
    @State var shouldPresentSortView = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    init() {
        UITableView.appearance().tableHeaderView = UIView()
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = .white
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().backgroundColor = .white
    }
    
    var dateInputView: some View {
        VStack(alignment: .leading) {
            Text(TextFieldTitle.date).foregroundColor(Color.gray).font(Font.system(size: 12.0))
            DateTimePickerTextField(text: $viewModel.date, mode: .date, onSearch: {
                self.getRooms()
            })
            HorizontalLine()
        }
    }
    
    var timeInputView: some View {
        VStack(alignment: .leading) {
            Text(TextFieldTitle.timeslot).foregroundColor(Color.gray).font(Font.system(size: 12.0))
            DateTimePickerTextField(text: $viewModel.time, mode: .time, onSearch: {
                self.getRooms()
            })
            HorizontalLine()
        }
    }
    
    var roomListHeaderView: some View {
        HStack {
            Text(SectionTitle.rooms).foregroundColor(Color.gray).font(Font.system(size: 12.0))
            Spacer()
            Spacer()
            Button(action: {
                self.shouldPresentSortView = true
            }) {
                Text(RMButtonText.sort).foregroundColor(Color.black).font(Font.system(size: 12.0))
            }
        }.background(Color.white)
    }
    
    var roomListView: some View {
        List {
            Section(header: roomListHeaderView.listRowInsets(EdgeInsets())) {
                ForEach(viewModel.updatedRooms) { room in
                    RoomCardView(room: room)
                }
            }
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            NavigationView {
                VStack {
                    self.dateInputView
                    Spacer()
                    self.timeInputView.disabled(self.viewModel.date.isEmpty)
                    Spacer()
                    if !self.viewModel.updatedRooms.isEmpty {
                        self.roomListView.layoutPriority(1.0)
                    } else {
                        Spacer().layoutPriority(1.0)
                    }
                }
                .padding(14.0)
                .navigationBarTitle(Text(PageTitle.bookRoom), displayMode: .inline)
                .sheet(isPresented: self.$shouldPresentSortView, onDismiss: {
                    self.viewModel.applySort()
                }) {
                    SortModalView(shouldPresentSortView: self.$shouldPresentSortView,
                                  selectedSortType: self.$viewModel.selectedSortType)
                }
            }
        }
    }
    
    private func getRooms() {
        if self.viewModel.isFormValidated {
            self.viewModel.getRooms()
        }
    }
    
}
