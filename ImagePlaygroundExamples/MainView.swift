//
//  MainView.swift
//  ImagePlaygroundExamples
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            List {
                if #available(iOS 18.1, macOS 15.1, *) {
                    NavigationLink("Basic Example", destination: BasicExampleView())
                    NavigationLink("Simple Concept", destination: SimpleConceptView())
                    NavigationLink("Extracted Concept", destination: ExtractedConceptView())
                    NavigationLink("Source Image (Online URL)", destination: OnlineSourceImageView())
                    NavigationLink("Source Image (Photos)", destination: PhotoLibrarySourceImageView())
                    #if os(iOS)
                    NavigationLink("UIKit Integration", destination: UIKitExampleViewControllerRepresentable())
                    #elseif os(macOS)
                    NavigationLink("AppKit Integration", destination: AppKitExampleViewControllerRepresentable())
                    #endif
                } else {
                    #if os(iOS)
                    Text("No iOS 18.1 Support")
                    #elseif os(macOS)
                    Text("No macOS 15.1 Support")
                    #endif
                }
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Image Playground Examples")
            #endif
        } detail: {
            ContentUnavailableView("Select an example from the sidebar",
                                   systemImage: "filemenu.and.cursorarrow")
        }
        .navigationTitle("Image Playground Examples")
    }
}

#Preview { MainView() }
