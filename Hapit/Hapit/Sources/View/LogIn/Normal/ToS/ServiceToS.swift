//
//  ServiceToS.swift
//  Hapit
//
//  Created by 김응관 on 2023/01/17.
//

import SwiftUI
import WebKit

struct ServiceToS: UIViewRepresentable {
    var urlToLoad: String
    
    @MainActor
    func makeUIView(context: Context) -> WKWebView {
        
        guard let url = URL(string: self.urlToLoad) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        
        webView.load(URLRequest(url: url))
        return webView
    }
    
    //업데이트 ui view
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<ServiceToS>) {
        
    }
    
}
