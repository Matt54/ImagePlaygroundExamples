//
//  ExtractedConceptView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import ImagePlayground
import SwiftUI
import TipKit

@available(iOS 18.1, macOS 15.1, *)
struct ExtractedConceptView: View {
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    @State private var isImagePlaygroundPresented: Bool = false
    @State private var generatedImageURL: URL?
    @State private var conceptText: String = String.itsyBitsySpider
    @State private var conceptTitle: String = "Itsy Bitsy Spider"
    let tapImageTip = TapImageTip()
    let notSupportedTip = NotSupportedTip()
    
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
        .imagePlaygroundSheet(isPresented: $isImagePlaygroundPresented, concepts: [concept]) { url in
            self.generatedImageURL = url
        }
    }
    
    var concept: ImagePlaygroundConcept {
        ImagePlaygroundConcept.extracted(from: conceptText, title: conceptTitle)
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview {
    ExtractedConceptView()
}

extension String {
    static var itsyBitsySpider: String {
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
