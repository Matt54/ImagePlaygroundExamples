//
//  DownloadAndShareToolbarModifier.swift
//  ImagePlaygroundExamples
//

import SwiftUI

extension View {
    func downloadAndShareToolbar(url: URL?) -> some View {
        modifier(DownloadAndShareToolbarModifier(imageURL: url))
    }
}

struct DownloadAndShareToolbarModifier: ViewModifier {
    let imageURL: URL?
    
    func body(content: Content) -> some View {
        content.toolbar {
            if let imageURL {
                #if os(macOS)
                ToolbarItem {
                    Button(action: { downloadImage(from: imageURL) }) {
                        Label("Download Image", systemImage: "arrowshape.down.circle.fill")
                    }
                }
                #endif
                
                ToolbarItem {
                    ShareLink(item: imageURL) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}
