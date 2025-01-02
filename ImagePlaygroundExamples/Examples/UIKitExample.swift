//
//  UIKitExample.swift
//  ImagePlaygroundExamples
//

#if os(iOS)
import ImagePlayground
import SwiftUI

@available(iOS 18.1, macOS 15.1, *)
struct UIKitExampleViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIKitExampleViewController {
        return UIKitExampleViewController()
    }
    func updateUIViewController(_ uiViewController: UIKitExampleViewController, context: Context) { }
}

@available(iOS 18.1, macOS 15.1, *)
class UIKitExampleViewController: UIViewController {
    static var isImagePlaygroundAvailable: Bool {
        if #available(iOS 18.1, macOS 15.1, *), ImagePlaygroundViewController.isAvailable {
            return true
        } else {
            return false
        }
    }
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintColor = .systemGray3
        imageView.image = UIImage(systemName: "photo.fill")?.applyingSymbolConfiguration(
            UIImage.SymbolConfiguration(pointSize: 50, weight: .medium)
        )
        return imageView
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Tap here to display Image Playground", for: .normal)
        button.setTitle("Image Playground not available", for: .disabled)
        button.isEnabled = isImagePlaygroundAvailable
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(placeholderImageView)
        view.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
        
        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        let playground = ImagePlaygroundViewController()
        playground.delegate = self
        present(playground, animated: true, completion: nil)
    }
}

@available(iOS 18.1, macOS 15.1, *)
extension UIKitExampleViewController: ImagePlaygroundViewController.Delegate {
    func imagePlaygroundViewController(_ imagePlaygroundViewController: ImagePlaygroundViewController, didCreateImageAt imageURL: URL) {
        if let imageData = try? Data(contentsOf: imageURL),
           let image = UIImage(data: imageData) {
            imageView.image = image
            placeholderImageView.isHidden = true
        }
        dismiss(animated: true, completion: nil)
    }
}

@available(iOS 18.1, macOS 15.1, *)
#Preview { UIKitExampleViewControllerRepresentable() }
#endif
