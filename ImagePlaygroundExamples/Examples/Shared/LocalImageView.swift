//
//  LocalImageView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

#Preview {
    LocalImageView(imageURL: nil)
}

// Displays an image from a local file url
struct LocalImageView: View {
    let imageURL: URL?
    
    private var image: CGImage? {
        guard let url = imageURL,
              let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil)
        else { return nil }
        return cgImage
    }
    
    var body: some View {
        Group {
            if let cgImage = image {
                Image(cgImage, scale: 1.0, label: Text("Local Image"))
                    .resizable()
            } else {
                PlaceholderBlobView()
                    .frame(width: 160, height: 160)
            }
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(.gray)
        .frame(width: 200, height: 200)
        .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
