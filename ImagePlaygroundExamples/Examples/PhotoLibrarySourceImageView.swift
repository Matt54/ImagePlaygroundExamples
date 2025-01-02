//
//  PhotoLibrarySourceImageView.swift
//  ImagePlaygroundExamples
//

import ImagePlayground
import PhotosUI
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct PhotoLibrarySourceImageView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil
    @State private var showCancellationAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            if let sourceImage {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Source Image").opacity(0.5)
                    sourceImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            
            PhotosPicker(
                selection: $selectedPhotoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Select Source Photo", systemImage: "photo.fill")
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
            
            LocalImageView(imageURL: generatedImageURL)
            
            Button(action: { isImagePlaygroundPresented = true }) {
                Text(tapText)
            }
            .disabled(!supportsImagePlayground)
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
        .downloadAndShareToolbar(url: generatedImageURL)
        .onChange(of: selectedPhotoPickerItem) { _, newItem in
            Task {
                do {
                    if let data = try await newItem?.loadTransferable(type: Data.self),
                       let image = Image(data: data) {
                        DispatchQueue.main.async {
                            self.sourceImage = image
                        }
                    }
                } catch {
                    print("Error processing image: \(error)")
                }
            }
        }
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
    PhotoLibrarySourceImageView()
}
