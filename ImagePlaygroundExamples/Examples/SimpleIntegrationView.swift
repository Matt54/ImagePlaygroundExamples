//
//  SimpleIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/18/24.
//

import ImagePlayground
import SwiftUI
import TipKit

@available(iOS 18.1, macOS 15.1, *)
struct SimpleIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var showCancellationAlert: Bool = false
    let tapImageTip = TapImageTip()
    let notSupportedTip = NotSupportedTip()
    
    var body: some View {
        VStack(spacing: 20) {
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
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, onCompletion: { url in
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
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    SimpleIntegrationView()
}
