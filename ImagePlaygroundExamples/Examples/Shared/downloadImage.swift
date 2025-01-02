//
//  downloadImage.swift
//  ImagePlaygroundExamples
//

import SwiftUI
import UniformTypeIdentifiers

#if os(macOS)
func downloadImage(from url: URL) {
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
