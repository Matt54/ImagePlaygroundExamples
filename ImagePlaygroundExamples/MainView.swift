//
//  MainView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            List {
                if #available(iOS 18.1, macOS 15.1, *) {
                    NavigationLink("Simple Integration", destination: SimpleIntegrationView())
                    NavigationLink("Simple Concept", destination: SimpleConceptView())
                    NavigationLink("Extracted Concept", destination: ExtractedConceptView())
                    NavigationLink("Online URL Source Image", destination: SourceImageIntegrationView())
                    NavigationLink("Photo Library Source Image", destination: PhotoLibrarySourceImageIntegrationView())
                } else {
                    Text("No iOS 18.1 Support")
                }
            }
        } detail: {
            ContentUnavailableView("Select an example from the sidebar",
                                   systemImage: "doc.text.image.fill")
        }
        .navigationTitle("Image Playground Examples")
    }
}

#Preview {
    MainView()
}
