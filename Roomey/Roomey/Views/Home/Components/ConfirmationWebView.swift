//
//  ConfirmationWebView.swift
//  Roomey
//
//  Created by Lawrence Tan on 5/24/20.
//  Copyright © 2020 Lawrence Tan. All rights reserved.
//

import SwiftUI
import Combine
import WebKit

class ConfirmationWebViewModel: ObservableObject {
    
    @Published var isLoading: Bool = true
    @Published var isLoadingCompleted: Bool = false
    @Published var webView: WKWebView
    
    init (webView: WKWebView = WKWebView()) {
        self.webView = webView
    }
    
}

struct ConfirmationWebView: View, UIViewRepresentable {
    
    let webView: WKWebView
    
    typealias UIViewType = UIViewContainerView<WKWebView>
    
    @ObservedObject var viewModel: ConfirmationWebViewModel
    
    init(webView: WKWebView, viewModel: ConfirmationWebViewModel) {
        self.webView = webView
        self.viewModel = viewModel
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: ConfirmationWebViewModel
        
        init(_ viewModel: ConfirmationWebViewModel) {
            self.viewModel = viewModel
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("Getting Contents")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print(error.localizedDescription)
            viewModel.isLoadingCompleted = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print(error.localizedDescription)
            viewModel.isLoadingCompleted = false
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Contents Loaded")
            viewModel.isLoading = false
            viewModel.isLoadingCompleted = true
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<ConfirmationWebView>) -> ConfirmationWebView.UIViewType {
        webView.navigationDelegate = context.coordinator
        
        return UIViewContainerView()
    }
    
    func updateUIView(_ uiView: ConfirmationWebView.UIViewType, context: UIViewRepresentableContext<ConfirmationWebView>) {
        if uiView.contentView !== webView {
            uiView.contentView = webView
        }
    }
}

class UIViewContainerView<ContentView: UIView>: UIView {
    var contentView: ContentView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            if let contentView = contentView {
                addSubview(contentView)
                contentView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
                ])
            }
        }
    }
}

