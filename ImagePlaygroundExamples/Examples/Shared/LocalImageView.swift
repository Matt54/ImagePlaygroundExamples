//
//  LocalImageView.swift
//  ImagePlaygroundExamples
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
                Color.init(white: 0.95)
                    .overlay( Image(systemName: "photo.fill") )
            }
        }
        .aspectRatio(contentMode: .fit)
        .foregroundColor(Color.init(white: 0.75))
        .font(.system(size: 50))
        .frame(width: 200, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
