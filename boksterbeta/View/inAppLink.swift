//
//  inAppLink.swift
//  bokster
//
//  Created by zakaria on 06/04/2022.
//
import UIKit
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url: URL
        
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariView = SFSafariViewController(url: url)
        return safariView
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {

    }
}
