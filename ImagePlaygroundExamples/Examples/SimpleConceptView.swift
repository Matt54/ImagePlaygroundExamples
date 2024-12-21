//
//  SimpleConceptView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct SimpleConceptView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var conceptText: String = "A monkey on a pirate ship"

    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter concept", text: $conceptText)
                .textFieldStyle(.roundedBorder)
            
            Button(action: { isPresented = true }) {
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
        .imagePlaygroundSheet(isPresented: $isPresented, concept: conceptText) { url in
            self.generatedImageURL = url
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

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    SimpleIntegrationView()
}
