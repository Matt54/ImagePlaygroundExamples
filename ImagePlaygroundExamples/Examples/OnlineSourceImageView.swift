//
//  OnlineSourceImageView.swift
//  ImagePlaygroundExamples
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct OnlineSourceImageView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Source Image").opacity(0.5)
                Group {
                    if let image = sourceImage {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            Button(action: reset) {
                Text("Tap for new random image")
            }

            Divider()
                .padding(.vertical, 10)
            
            LocalImageView(imageURL: generatedImageURL)
            
            Button(action: { isImagePlaygroundPresented = true }) {
                Text(tapText)
            }
            .disabled(!supportsImagePlayground)
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, sourceImage: sourceImage, onCompletion: { url in
            self.generatedImageURL = url
        })
        .downloadAndShareToolbar(url: generatedImageURL)
        .onAppear {
            loadImage()
        }
    }
    
    private func reset() {
        sourceImage = nil
        generatedImageURL = nil
        loadImage()
    }
    
    private func loadImage() {
        guard let url = URL(string: "https://picsum.photos/1000") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
                let downloadedImage = Image(data: data) {
                DispatchQueue.main.async {
                    self.sourceImage = downloadedImage
                }
            }
        }.resume()
    }
    
    var tapText: String {
        if supportsImagePlayground {
            return "Tap here to display Image Playground"
        } else {
            return "Image Playground not supported"
        }
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    OnlineSourceImageView()
}
