//
//  AppKitExample.swift
//  ImagePlaygroundExamples
//

#if os(macOS)
import AppKit
import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct AppKitExampleRepresentable: NSViewControllerRepresentable {
    func makeNSViewController(context: Context) -> AppKitExampleViewController {
        return AppKitExampleViewController()
    }
    
    func updateNSViewController(_ nsViewController: AppKitExampleViewController, context: Context) { }
}

@available(iOS 18.1, macOS 15.1, *)
class AppKitExampleViewController: NSViewController {
    static var isImagePlaygroundAvailable: Bool {
        if #available(iOS 18.1, macOS 15.1, *), ImagePlaygroundViewController.isAvailable {
            return true
        } else {
            return false
        }
    }
    
    private lazy var containerView: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.systemGray.withAlphaComponent(0.2).cgColor
        view.layer?.cornerRadius = 4
        return view
    }()
    
    private lazy var imageView: NSImageView = {
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        return imageView
    }()
    
    private lazy var placeholderImageView: NSImageView = {
        let imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleNone
        let config = NSImage.SymbolConfiguration(pointSize: 50, weight: .medium)
        imageView.image = NSImage(systemSymbolName: "photo.fill", accessibilityDescription: nil)?
            .withSymbolConfiguration(config)
        imageView.contentTintColor = .systemGray
        return imageView
    }()
    
    private lazy var actionButton: NSButton = {
        let button = NSButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.title = "Tap here to display Image Playground"
        button.isEnabled = Self.isImagePlaygroundAvailable
        if !Self.isImagePlaygroundAvailable {
            button.title = "Image Playground not available"
        }
        button.bezelStyle = .rounded
        button.target = self
        button.action = #selector(buttonTapped)
        return button
    }()
    
    override func loadView() {
        self.view = NSView()
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(placeholderImageView)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            containerView.widthAnchor.constraint(equalToConstant: 200),
            containerView.heightAnchor.constraint(equalToConstant: 200),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            placeholderImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            actionButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 20),
            actionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func buttonTapped() {
        let playground = ImagePlaygroundViewController()
        playground.delegate = self
        self.presentAsSheet(playground)
    }
}

@available(iOS 18.1, macOS 15.1, *)
extension AppKitExampleViewController: ImagePlaygroundViewController.Delegate {
    func imagePlaygroundViewController(_ imagePlaygroundViewController: ImagePlaygroundViewController, didCreateImageAt imageURL: URL) {
        if let image = NSImage(contentsOf: imageURL) {
            imageView.image = image
            placeholderImageView.isHidden = true
        }
        dismiss(imagePlaygroundViewController)
    }
    
    func imagePlaygroundViewControllerDidCancel(_ imagePlaygroundViewController: ImagePlaygroundViewController) {
        dismiss(animated: true, completion: nil)
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview { AppKitExampleRepresentable() }
#endif
