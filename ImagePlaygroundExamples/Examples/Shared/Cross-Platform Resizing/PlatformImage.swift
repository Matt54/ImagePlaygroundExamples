//
//  PlatformImage.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/21/24.
//

import SwiftUI

#if os(iOS)
typealias PlatformImage = UIImage
#else
typealias PlatformImage = NSImage
#endif

extension Image {
    init (platformImage: PlatformImage) {
        #if os(iOS)
        self.init(uiImage: platformImage)
        #else
        self.init(nsImage: platformImage)
        #endif
    }
}
