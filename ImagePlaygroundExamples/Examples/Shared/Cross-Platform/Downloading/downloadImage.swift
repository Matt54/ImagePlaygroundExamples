//
//  downloadImage.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/22/24.
//

import SwiftUI
import UniformTypeIdentifiers

func downloadImage(from url: URL) {
    #if os(iOS)
    downloadImageiOS(from: url)
    #else
    downloadImageMacOS(from: url)
    #endif
}

#if os(iOS)
private func downloadImageiOS(from url: URL) {
    // For iOS, use UIActivityViewController to share/save the image
    let activityVC = UIActivityViewController(
        activityItems: [url],
        applicationActivities: nil
    )
    
    // Get the window scene to present the activity view controller
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let window = windowScene.windows.first,
       let rootViewController = window.rootViewController {
        rootViewController.present(activityVC, animated: true)
    }
}
#endif

#if os(macOS)
private func downloadImageMacOS(from url: URL) {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = [UTType.image]
    savePanel.nameFieldStringValue = url.lastPathComponent
    
    savePanel.begin { response in
        if response == .OK, let saveURL = savePanel.url {
            do {
                try FileManager.default.copyItem(at: url, to: saveURL)
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }
}
#endif
