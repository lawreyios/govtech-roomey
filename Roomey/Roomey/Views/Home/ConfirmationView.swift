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
            Button(action: {
                self.dismiss()
            }) {
                Text("Back to Home")
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
