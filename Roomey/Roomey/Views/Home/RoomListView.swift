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
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var dateInputView: some View {
        VStack(alignment: .leading) {
            Text(TextFieldTitle.date)
                .modifier(FontModifier(appFont: .regular, size: 12.0, color: Color.appColor(.submarine)))
            DateTimePickerTextField(text: $viewModel.date, mode: .date, onSearch: {
                self.viewModel.getRooms()
            }, isFirstResponder: viewModel.isDateFieldFirstResponder)
            HorizontalLine()
        }
    }
    
    var timeInputView: some View {
        VStack(alignment: .leading) {
            Text(TextFieldTitle.timeslot)
                .modifier(FontModifier(appFont: .regular, size: 12.0, color: Color.appColor(.submarine)))
            DateTimePickerTextField(text: $viewModel.time, mode: .time, onSearch: {
                self.viewModel.getRooms()
            })
            HorizontalLine()
        }
    }
    
    var roomListHeaderView: some View {
        HStack {
            Text(SectionTitle.rooms)
                .modifier(FontModifier(appFont: .regular, size: 12.0, color: Color.appColor(.submarine)))
            Spacer()
            Spacer()
            Button(action: { self.viewModel.presentSortView() }) {
                HStack {
                    Spacer()
                    Text(RMButtonText.sort)
                        .modifier(FontModifier(appFont: .bold, size: 12.0, color: .black))
                        .multilineTextAlignment(.trailing)
                    Image(Icon.sort)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22.0, height: 22.0, alignment: .trailing)
                        .foregroundColor(.black)
                }
            }
        }
        .frame(height: 44.0)
        .background(Color.white)
    }
    
    var roomListView: some View {
        List {
            Section(header: roomListHeaderView.listRowInsets(EdgeInsets())) {
                ForEach(viewModel.updatedRooms) { room in
                    RoomCardView(room: room).padding(.horizontal, -20.0)
                }
            }
        }.padding(.top, 28.0)
    }
    
    var cameraButton: some View {
        NavigationLink(destination: ConfirmationView(webViewURL: self.$viewModel.webViewURL),
                       isActive: .constant(!$viewModel.webViewURL.wrappedValue.isEmpty)) {
                        Button(action: { self.viewModel.presentQRCodeScannerView() }) {
                            Image(Icon.camera)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50.0, height: 22.0, alignment: .trailing)
                        }
        }
    }
    
    var qrCodeScanningView: some View {
        QRCodeScannerView(codeTypes: [.qr]) { result in
            self.viewModel.handleQRCodeScanInput(result)
        }
    }
    
    var sheetView: AnyView {
        switch viewModel.modalViewType {
            case .sort:
                return AnyView(SortModalView(shouldPresentSortView: self.$viewModel.shouldPresentModal,
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
                            self.timeInputView.disabled(self.viewModel.date.isEmpty).padding(.top, 28.0)
                            Spacer()
                            if !self.viewModel.updatedRooms.isEmpty {
                                self.roomListView.layoutPriority(1.0)
                            } else {
                                Spacer().layoutPriority(1.0)
                            }
                        }
                        .padding(28.0)
                        .navigationBarTitle(Text(PageTitle.bookRoom), displayMode: .inline)
                        .sheet(isPresented: self.$viewModel.shouldPresentModal, onDismiss: {
                            self.viewModel.handleSheetDismiss()
                        }) {
                            self.sheetView
                        }
                        .navigationBarItems(trailing: self.cameraButton)
                        .alert(isPresented: self.$viewModel.shouldShowAlert)  {
                            self.handleAlerts()
                        }
                    }
                }
            } else {
                ZStack(alignment: .center) {
                    VStack {
                        Text(InfoText.noInternet).multilineTextAlignment(.center).font(Font.body)
                            .font(Font.system(size: 20.0)).padding(.bottom, 14.0)
                        Button(action: {
                            UIApplication.goToSettings()
                        }) {
                            Text(RMButtonText.settings)
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
    
    private func handleAlerts() -> Alert {
        switch viewModel.scanError {
        case .invalid: return Alert.invalidQRCodeAlert
        case .noPermission: return Alert.cameraPermissionAlert
        case .none: return Alert.init(title: Text(verbatim: .empty))
        }
    }
    
}
