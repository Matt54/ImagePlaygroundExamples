//
//  resizeImageIfNeeded.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/21/24.
//

import SwiftUI

func resizeImageIfNeeded(_ image: PlatformImage, maxDimension: CGFloat = 1024) -> PlatformImage? {
    #if os(iOS)
    return resizeUIImageIfNeeded(image, maxDimension: maxDimension)
    #elseif os(macOS)
    return resizeNSImageIfNeeded(image, maxDimension: maxDimension)
    #endif
}

#if os(iOS)
private func resizeUIImageIfNeeded(_ image: UIImage, maxDimension: CGFloat) -> UIImage? {
    // First correct the image orientation to up
    let fixedImage: UIImage
    if image.imageOrientation != .up {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        fixedImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
        UIGraphicsEndImageContext()
    } else {
        fixedImage = image
    }
    
    // Check if resizing is needed
    let scale = min(maxDimension / fixedImage.size.width, maxDimension / fixedImage.size.height)
    if scale < 1 {
        let newSize = CGSize(
            width: fixedImage.size.width * scale,
            height: fixedImage.size.height * scale
        )
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        fixedImage.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    return fixedImage
}
#endif

#if os(macOS)
private func resizeNSImageIfNeeded(_ image: NSImage, maxDimension: CGFloat) -> NSImage? {
    // Get the image size
    let imageSize = image.size
    
    // Check if resizing is needed
    let scale = min(maxDimension / imageSize.width, maxDimension / imageSize.height)
    if scale < 1 {
        let newSize = CGSize(
            width: imageSize.width * scale,
            height: imageSize.height * scale
        )
        
        // Create a new NSImage with the scaled size
        let resizedImage = NSImage(size: newSize)
        resizedImage.lockFocus()
        
        image.draw(in: CGRect(origin: .zero, size: newSize),
                  from: CGRect(origin: .zero, size: imageSize),
                  operation: .copy,
                  fraction: 1.0)
        
        resizedImage.unlockFocus()
        return resizedImage
    }
    
    return image
}
#endif
