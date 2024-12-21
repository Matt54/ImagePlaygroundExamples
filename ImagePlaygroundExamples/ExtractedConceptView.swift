//
//  ExtractedConceptView.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/20/24.
//

import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct ExtractedConceptView: View {
    @State private var isPresented: Bool = false
    @State private var url: URL?
    
    @State private var conceptText: String = String.itsyBitsySpider
    @State private var conceptTitle: String = "Itsy Bitsy Spider"
    
    var text: String {
        if supportsImagePlayground {
            return "Tap Above to generate new image"
        } else {
            return "Image Playground Not Supported"
        }
    }
    
    @Environment(\.supportsImagePlayground) private var supportsImagePlayground
    
    var concept: ImagePlaygroundConcept {
        ImagePlaygroundConcept.extracted(from: conceptText, title: conceptTitle)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Title").opacity(0.5)
                TextField("Enter concept title", text: $conceptTitle)
                    .textFieldStyle(.roundedBorder)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Text").opacity(0.5)
                TextEditor(text: $conceptText)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke().opacity(0.125))
            }
            
            Divider()
            
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
        .imagePlaygroundSheet(isPresented: $isPresented, concepts: [concept]) { url in
            self.url = url
        }
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
