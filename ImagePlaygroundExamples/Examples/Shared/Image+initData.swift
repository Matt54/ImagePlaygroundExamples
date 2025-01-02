//
//  Image+initData.swift
//  ImagePlaygroundExamples
//

import SwiftUI

extension Image {
    init?(data: Data) {
        #if os(iOS)
        guard let uiImage = UIImage(data: data) else { return nil }
        self.init(uiImage: uiImage)
        #else
        guard let nsImage = NSImage(data: data) else { return nil }
        self.init(nsImage: nsImage)
        #endif
    }
}
