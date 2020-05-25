//
//  ConfirmationView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI

struct ConfirmationView: View {
    
    @Binding var webViewURL: String
    @ObservedObject var confirmationWebViewModel = ConfirmationWebViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            LoadingView(isShowing: self.$confirmationWebViewModel.isLoading) {
                ConfirmationWebView(
                    webView: self.confirmationWebViewModel.webView,
                    viewModel: self.confirmationWebViewModel
                )
            }
            Spacer()
            Spacer()
            if self.$confirmationWebViewModel.isLoadingCompleted.wrappedValue {
                Button(action: {
                    self.dismiss()
                }) {
                    HStack {
                        Spacer()
                        Text(RMButtonText.backToHome).modifier(FontModifier(appFont: .bold, size: 20, color: .white))
                        Spacer()
                    }
                    .frame(height: 55.0)
                    .background(Color.appColor(.crayonBlue))
                    .cornerRadius(20.0, corners: .allCorners)
                    .padding(.horizontal, 14.0)
                }
            }
        }.onAppear {
            if let url = URL(string: self.webViewURL) {
                let request = URLRequest(url: url)
                self.confirmationWebViewModel.webView.load(request)
            }
        }
        .navigationBarTitle(Text(PageTitle.bookRoom), displayMode: .inline)
        .navigationBarItems(leading:
        Button(action: {
            self.dismiss()
        }) {
            HStack {
                Image(Icon.back)
                    .resizable()
                    .frame(width: 23.0, height: 14.0, alignment: .center)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.blue)
            }
        })
    }
    
    private func dismiss() {
        webViewURL = .empty
        presentationMode.wrappedValue.dismiss()
    }
    
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(webViewURL: .constant(""))
    }
}
