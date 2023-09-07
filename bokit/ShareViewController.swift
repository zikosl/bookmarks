//
//  ShareViewController.swift
//  bokit
//
//  Created by ziko on 13/3/2022.
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController {
    
    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)
    private var appURLString = "bokster://share?url="

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Get the all encompasing object that holds whatever was shared. If not, dismiss view.
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
            let itemProvider = extensionItem.attachments?.first else {
                self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
                return
        }

        // Check if object is of type text
        if itemProvider.hasItemConformingToTypeIdentifier(typeText) {
            handleIncomingText(itemProvider: itemProvider)
        // Check if object is of type URL
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            handleIncomingURL(itemProvider: itemProvider)
        } else {
            print("Error: No url or text found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    private func handleIncomingText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeText, options: nil) { (item, error) in
            if let error = error {
                print("Text-Error: \(error.localizedDescription)")
            }

            if let text = item as? String {
                do {
                    // Detect URLs in String
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(
                        in: text,
                        options: [],
                        range: NSRange(location: 0, length: text.utf16.count)
                    )
                    // Get first URL found
                    if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                        self.appURLString += text[range]
                    }
                } catch let error {
                    print("Do-Try Error: \(error.localizedDescription)")
                }
            }

            self.openMainApp()
        }
    }

    private func handleIncomingURL(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
            if let error = error {
                print("URL-Error: \(error.localizedDescription)")
            }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                self.appURLString += urlString
            }

            self.openMainApp()
        }
    }
    
    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURLString) else { return }
            _ = self.openURL(url)
        })
    }
    
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
