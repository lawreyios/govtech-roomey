//
//  RoomListView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/22/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

struct RoomListView: View {
    
    enum ModalViewType: Int {
        case qrCodeScanner, sort, none
    }
    
    @ObservedObject var viewModel = RoomListViewModel()
    
    @State var shouldPresentModal = false
    @State var shouldShowAlert = false
    @State var webViewURL = String.empty
    @State var scanError = QRCodeScannerView.ScanError.none
    @State var modalViewType = ModalViewType.none
    
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
                self.modalViewType = .sort
                self.shouldPresentModal = true
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
    
    var cameraButton: some View {
        NavigationLink(destination: ConfirmationView(webViewURL: self.$webViewURL),
                       isActive: .constant(!$webViewURL.wrappedValue.isEmpty)) {
                        Button(action: {
                            self.modalViewType = .qrCodeScanner
                            self.shouldPresentModal = true
                        }) {
                            Image(Icon.camera)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50.0, height: 22.0, alignment: .trailing)
                        }
        }
    }
    
    var qrCodeScanningView: some View {
        QRCodeScannerView(codeTypes: [.qr]) { result in
            switch result {
            case .success(let code):
                self.scanError = .none
                self.shouldShowAlert = false
                self.webViewURL = code
            case .failure(let error):
                self.scanError = error
            }
            
            self.shouldPresentModal = false
        }
    }
    
    var sheetView: AnyView {
        switch modalViewType {
            case .sort:
                return AnyView(SortModalView(shouldPresentSortView: self.$shouldPresentModal,
                          selectedSortType: self.$viewModel.selectedSortType))
            case .qrCodeScanner: return AnyView(qrCodeScanningView)
            case .none: break
        }
        
        return AnyView(EmptyView())
    }
    
    var body: some View {
        ZStack {
            if $viewModel.networkStatus.wrappedValue == .satisfied {
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
                        .sheet(isPresented: self.$shouldPresentModal, onDismiss: {
                            self.handleSheetDismiss()
                        }) {
                            self.sheetView
                        }
                        .navigationBarItems(trailing: self.cameraButton)
                        .alert(isPresented: self.$shouldShowAlert)  {
                            self.handleAlerts()
                        }
                    }
                }
            } else {
                ZStack(alignment: .center) {
                    VStack {
                        Text("No internet connection\nPlease check your settings").multilineTextAlignment(.center).font(Font.body)
                            .font(Font.system(size: 20.0)).padding(.bottom, 14.0)
                        Button(action: {
                            UIApplication.goToSettings()
                        }) {
                            Text("Go to Settings")
                        }
                    }
                }
            }
        }.onAppear {
            self.viewModel.startMonitoringNetwork()
        }.onDisappear {
            self.viewModel.stopMonitoringNetwork()
        }
    }
    
    private func getRooms() {
        if self.viewModel.isFormValidated {
            self.viewModel.getRooms()
        }
    }
    
    private func handleSheetDismiss() {
        switch modalViewType {
        case .sort: viewModel.applySort()
        case .qrCodeScanner: showAlertIfError()
        case .none: break
        }
        
        self.modalViewType = .none
    }
    
    private func showAlertIfError() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if self.$scanError.wrappedValue != .none {
                self.shouldShowAlert = true
            }
        }
    }
    
    private func handleAlerts() -> Alert {
        switch scanError {
        case .invalid: return Alert.invalidQRCodeAlert
        case .noPermission: return Alert.cameraPermissionAlert
        case .none: return Alert.init(title: Text(verbatim: .empty))
        }
    }
    
}
