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
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            if let image {
                Text("Source Image")
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            PhotosPicker(
                selection: $selectedItem,
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
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isPresented, sourceImage: image) { url in
            self.url = url
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                do {
                    if let data = try await newItem?.loadTransferable(type: Data.self),
                       let rawImage = UIImage(data: data),
                       let processedImage = processImage(rawImage, maxDimension: 1024) {
                        DispatchQueue.main.async {
                            self.image = Image(uiImage: processedImage)
                        }
                    }
                } catch {
                    print("Error processing image: \(error)")
                }
            }
        }
    }

    // Function to resize image if needed while maintaining aspect ratio
    private func processImage(_ image: UIImage, maxDimension: CGFloat = 1024) -> UIImage? {
        // First correct the image orientation to up
        let fixedImage: UIImage
        if image.imageOrientation != .up {
            UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
            image.draw(in: CGRect(origin: .zero, size: image.size))
            fixedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        } else {
            fixedImage = image
        }
        
        // Check if resizing is needed
        let scale = min(maxDimension / fixedImage.size.width, maxDimension / fixedImage.size.height)
        if scale < 1 {
            let newSize = CGSize(
                width: fixedImage.size.width * scale,
                height: fixedImage.size.height * scale
            )
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            fixedImage.draw(in: CGRect(origin: .zero, size: newSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return resizedImage
        }
        
        return fixedImage
    }
}
