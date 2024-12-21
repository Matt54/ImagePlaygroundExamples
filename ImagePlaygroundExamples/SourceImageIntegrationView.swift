//
//  SourceImageIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct SourceImageIntegrationView: View {
    @State private var isPresented: Bool = false
    @State private var url: URL?
    
    var text: String {
        if supportsImagePlayground {
            return "Tap Above to generate new image"
        } else {
            return "Image Playground Not Supported"
        }
    }
    
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    
    @State private var image: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = image {
                Text("Source Image")
                Button(action: reset) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text("Tap for new random image")
                
                Divider()
                    .padding(.vertical, 10)
                
                Text("Generated Image")
                Button(action: { isPresented = true }) {
                    LocalImageView(imageURL: url)
                        .frame(width: 200, height: 200)
                        .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(!supportsImagePlayground)
                
                Text(text)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isPresented, sourceImage: image) { url in
            self.url = url
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func reset() {
        image = nil
        url = nil
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = PlatformImage(data: data) {
                DispatchQueue.main.async {
                    self.image = Image(platformImage: downloadedImage)
                }
            }
        }.resume()
    }
}
