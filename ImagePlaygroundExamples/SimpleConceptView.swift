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
    @State private var isPresented: Bool = false
    @State private var url: URL?
    
    @State private var conceptText: String = "A monkey on a pirate ship"
    
    var text: String {
        if supportsImagePlayground {
            return "Tap Above to generate new image"
        } else {
            return "Image Playground Not Supported"
        }
    }
    
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    
    var body: some View {
        VStack(spacing: 20) {
            
            TextField("Enter concept", text: $conceptText)
                .textFieldStyle(.roundedBorder)
            
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
        .imagePlaygroundSheet(isPresented: $isPresented, concept: conceptText) { url in
            self.url = url
        }
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    SimpleIntegrationView()
}
