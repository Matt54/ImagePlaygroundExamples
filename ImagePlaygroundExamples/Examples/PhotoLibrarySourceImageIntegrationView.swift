//
//  PhotoLibrarySourceImageIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI
import PhotosUI

@available(iOS 18.1, macOS 15.1, *)
struct PhotoLibrarySourceImageIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            if let sourceImage {
                Text("Source Image")
                sourceImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            PhotosPicker(
                selection: $selectedPhotoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Select Photo", systemImage: "photo.fill")
                    .foregroundColor(.blue)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.blue, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
            
            Divider()
                .padding(.vertical, 10)
            
            Text("Generated Image")
            Button(action: { isImagePlaygroundPresented = true }) {
                LocalImageView(imageURL: generatedImageURL)
                    .frame(width: 200, height: 200)
                    .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(!supportsImagePlayground)
            
            Text(text)
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, sourceImage: sourceImage) { url in
            self.generatedImageURL = url
        }
        .onChange(of: selectedPhotoPickerItem) { _, newItem in
            Task {
                do {
                    if let data = try await newItem?.loadTransferable(type: Data.self),
                       let rawImage = PlatformImage(data: data),
                       let processedImage = resizeImageIfNeeded(rawImage, maxDimension: 1024) {
                        DispatchQueue.main.async {
                            self.sourceImage = Image(platformImage: processedImage)
                        }
                    }
                } catch {
                    print("Error processing image: \(error)")
                }
            }
        }
    }
    
    var text: String {
        if supportsImagePlayground {
            return "Tap Above to generate new image"
        } else {
            return "Image Playground Not Supported"
        }
    }
}
