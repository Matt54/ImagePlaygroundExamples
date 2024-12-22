//
//  ImagePlaygroundExamplesApp.swift
//  ImagePlaygroundExamples
//
//  Created by Matt Pfeiffer on 12/18/24.
//

import SwiftUI
import TipKit

@main
struct ImagePlaygroundExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .task {
                    do {
                        try? Tips.resetDatastore() // reset tips so they show each time
                        try Tips.configure()
                    }
                    catch { print("Error initializing TipKit \(error.localizedDescription)") }
                }
        }
    }
}

struct TapImageTip: Tip {
    var title: Text {
        Text("Tap to open image playground")
    }
}

struct NotSupportedTip: Tip {
    var title: Text {
        Text("Image Playground Not Supported")
    }
}

struct TapForRandomImageTip: Tip {
    var title: Text {
        Text("Tap for new random image")
    }
}
