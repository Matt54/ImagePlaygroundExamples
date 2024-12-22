//
//  PhotoLibrarySourceImageIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import PhotosUI
import SwiftUI
import TipKit

@available(iOS 18.1, macOS 15.1, *)
struct PhotoLibrarySourceImageIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var sourceImage: Image?
    @State private var selectedPhotoPickerItem: PhotosPickerItem? = nil
    @State private var showCancellationAlert: Bool = false
    let tapImageTip = TapImageTip()
    let notSupportedTip = NotSupportedTip()
    
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
        .toolbar {
            if let generatedImageURL {
                ToolbarItem {
                    Button(action: { downloadImage(from: generatedImageURL) }) {
                        Label("Download Image", systemImage: "arrowshape.down.circle.fill")
                    }
                }
                ToolbarItem {
                    ShareLink(item: generatedImageURL) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                }
            }
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
}

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    PhotoLibrarySourceImageIntegrationView()
}
