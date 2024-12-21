//
//  SimpleIntegrationView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/18/24.
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct SimpleIntegrationView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isPresented: Bool = false
    @State private var url: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: { isPresented = true }) {
                LocalImageView(imageURL: url)
                    .frame(width: 200, height: 200)
                    .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .buttonStyle(.plain)
            .disabled(!supportsImagePlayground)
            
            Text(text)
        }
        .padding(20)
        .imagePlaygroundSheet(isPresented: $isPresented) { url in
            self.url = url
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
