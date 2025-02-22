//
//  SimpleConceptView.swift
//  ImagePlaygroundExamples
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct SimpleConceptView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var conceptText: String = "A monkey on a pirate ship"
    @State private var showCancellationAlert: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Concept").opacity(0.5)
                TextField("Enter concept", text: $conceptText)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 4).fill().opacity(0.125)
                            RoundedRectangle(cornerRadius: 4).stroke(Color.init(white:0.3))
                        }
                    )
            }
            
            Divider()
            
            LocalImageView(imageURL: generatedImageURL)
            
            Button(action: { isImagePlaygroundPresented = true }) {
                Text(tapText)
            }
            .disabled(!supportsImagePlayground)
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, concept: conceptText, onCompletion: { url in
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
    SimpleConceptView()
}
