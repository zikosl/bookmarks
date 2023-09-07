//
//  URLButton.swift
//  bokster
//
//  Created by zakaria on 06/04/2022.
//

import SwiftUI


struct URLButton<Content: View>: View {
    // What to display on the buton/ the link
    var content: Content
    var url: String
    
    @AppStorage("LinkDestination") var linkDestination = 0
    
    @State var showSafariView = false
    
    // Use this to explicitly open the url in Safari. With iOS 14 the user can change the default browser.
    var safariURL: String {
        if (url.contains("https://") || url.contains("http://")) {
            return  url
        }
        else {
            return "https://\(url)"
        }
    }
    
    var googleChromeURL: String {
        if url.contains("https://") {
            return url.replacingOccurrences(of: "https://", with: "googlechrome://")
        } else if url.contains("http://") {
            return url.replacingOccurrences(of: "http://", with: "googlechrome://")
        } else {
            return "googlechrome://\(url)"
        }
    }

    @ViewBuilder var body: some View {
        switch linkDestination {
        case 0:
            // A button, that toggles a full screen cover with a SFSafariViewController
            Button(action: {
                showSafariView = true
            }) {
                content.fullScreenCover(isPresented: $showSafariView) {
                    SafariView(url: URL(string: url)!).edgesIgnoringSafeArea(.all)
                }
            }
        case 1:
            // Opens the URL in Safari
            Link(destination: URL(string: safariURL)!) {
                content
            }
        case 2:
            Link(destination: URL(string: googleChromeURL)!) {
                content
            }
        default:
            content
        }
    }
}


/*struct URLButton_Previews: PreviewProvider {
    static var previews: some View {
        URLButton()
    }
}*/
