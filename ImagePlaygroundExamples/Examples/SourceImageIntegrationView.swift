//
//  SourceImageIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct SourceImageIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?

    var body: some View {
        VStack(spacing: 20) {
            if let image = sourceImage {
                Text("Source Image")
                Button(action: reset) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                Text("Tap for new random image")
                
                Divider()
                    .padding(.vertical, 10)
                
                Text("Generated Image")
                Button(action: { isPresented = true }) {
                    LocalImageView(imageURL: generatedImageURL)
                        .frame(width: 200, height: 200)
                        .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .buttonStyle(.plain)
                .disabled(!supportsImagePlayground)
                
                Text(text)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isPresented, sourceImage: sourceImage) { url in
            self.generatedImageURL = url
        }
        .onAppear {
            loadImage()
        }
    }
    
    var text: String {
        if supportsImagePlayground {
            return "Tap Above to generate new image"
        } else {
            return "Image Playground Not Supported"
        }
    }
    
    private func reset() {
        sourceImage = nil
        generatedImageURL = nil
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = PlatformImage(data: data) {
                DispatchQueue.main.async {
                    self.sourceImage = Image(platformImage: downloadedImage)
                }
            }
        }.resume()
    }
}
