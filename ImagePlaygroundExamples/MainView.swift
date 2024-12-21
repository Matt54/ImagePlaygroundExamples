//
//  MainView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            Form {
                if #available(iOS 18.1, macOS 15.1, *) {
                    NavigationLink("Simple Integration", destination: SimpleIntegrationView())
                    NavigationLink("Simple Concept", destination: SimpleConceptView())
                    NavigationLink("Extracted Concept", destination: ExtractedConceptView())
                    NavigationLink("Online URL Source Image Integration", destination: SourceImageIntegrationView())
                    NavigationLink("Photo Library Source Image Integration", destination: PhotoLibrarySourceImageIntegrationView())
                } else {
                    Text("No iOS 18.1 Support")
                }
            }
            #if os(iOS)
            .navigationBarTitle("Image Playground Examples")
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}

#Preview {
    MainView()
}
