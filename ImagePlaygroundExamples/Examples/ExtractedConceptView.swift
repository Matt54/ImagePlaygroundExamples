//
//  ExtractedConceptView.swift
//  ImagePlaygroundExamples
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct ExtractedConceptView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var conceptText: String = String.itsyBitsySpiderStoryText
    @State private var conceptTitle: String = "Itsy Bitsy Spider"
    @State private var showCancellationAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Title").opacity(0.5)
                TextField("Enter concept title", text: $conceptTitle)
                    .textFieldStyle(.plain)
                    .padding(8)
                    .background(
                        ZStack {
                            RoundedRectangle(cornerRadius: 4).fill().opacity(0.125)
                            RoundedRectangle(cornerRadius: 4).stroke(Color.init(white:0.3))
                        }
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Text").opacity(0.5)
                TextEditor(text: $conceptText)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 100)
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
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, concepts: [concept], onCompletion: { url in
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
    var concept: ImagePlaygroundConcept {
        ImagePlaygroundConcept.extracted(from: conceptText, title: conceptTitle)
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
    ExtractedConceptView()
}

extension String {
    static var itsyBitsySpiderStoryText: String {
        """
        The itsy bitsy spider climbed up the waterspout.
        Down came the rain
        And washed the spider out.
        Out came the sun
        And dried up all the rain
        And the itsy bitsy spider climbed up the spout again.
        """
    }
}
