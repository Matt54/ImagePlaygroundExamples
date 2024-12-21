//
//  LocalImageView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

// Displays an image from a local file url
struct LocalImageView: View {
    let imageURL: URL?
    
    private var image: CGImage? {
        guard let url = imageURL,
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else {
            return nil
        }
        return cgImage
    }
    
    var body: some View {
        Group {
            if let cgImage = image {
                Image(cgImage, scale: 1.0, label: Text("Local Image"))
                    .resizable()
            } else {
                // Fallback view if no URL or image can't be loaded
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.gray)
    }
}
