//
//  SourceImageIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI
import TipKit

@available(iOS 18.1, macOS 15.1, *)
struct SourceImageIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?
    @State private var showCancellationAlert: Bool = false
    let tapImageTip = TapImageTip()
    let notSupportedTip = NotSupportedTip()
    let tapForRandomImageTip = TapForRandomImageTip()
    
    var body: some View {
        VStack(spacing: 20) {
            if let image = sourceImage {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Source Image").opacity(0.5)
                    Button(action: reset) {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .buttonStyle(.plain)
                }
                
                TipView(tapForRandomImageTip, arrowEdge: .top)
                    .frame(height: 50) // macOS expands to large frame otherwise
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
            }
            
            
            
            Divider()
                .padding(.vertical, 10)
            
            Button(action: { isImagePlaygroundPresented = true }) {
                LocalImageView(imageURL: generatedImageURL)
                    .frame(width: 200, height: 200)
                    .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(!supportsImagePlayground)
            
            TipView(supportsImagePlayground ? tapImageTip: notSupportedTip, arrowEdge: .top)
                .frame(height: 50) // macOS expands to large frame otherwise
            
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, sourceImage: sourceImage, onCompletion: { url in
            self.generatedImageURL = url
        }, onCancellation: {
            showCancellationAlert = true
        })
        .alert("Generation Cancelled", isPresented: $showCancellationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("The image generation was cancelled.")
        }
        
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
        guard let url = URL(string: "https://picsum.photos/1100") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let downloadedImage = PlatformImage(data: data) {
                DispatchQueue.main.async {
                    self.sourceImage = Image(platformImage: downloadedImage)
                }
            }
        }.resume()
    }
}
