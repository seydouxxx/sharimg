//
//  ShareViewController.swift
//  share
//
//  Created by Lee Hojun on 2023/01/29.
//

import UIKit
import Social
import UniformTypeIdentifiers

import Combine


final class ShareViewController: UIViewController {
  
  @Published var images: [UIImage] = [] {
    didSet {
      print(images.count)
      images.forEach { print($0.size) }
    }
  }
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  internal var subscribers = Set<AnyCancellable>()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()
    self.configureView()
    self.layoutView()
  }
  
  internal func getContentSources() {
    
    guard
      let extensionItems = extensionContext?.inputItems as? [NSExtensionItem]
    else { return }
    
    let providers = extensionItems
      .map { $0.attachments?
        .compactMap { $0 }
        .first
      }
      .compactMap { $0 }
    print("----")
    Task {
      var images: [UIImage?] = []
      for provider in providers {
        try await images.append(_convertSourceToImage(provider))
      }
      self.images = images.compactMap { $0 }
    }
    print("=====")
  }
  
  private func _convertSourceToImage(_ from: NSItemProvider) async throws -> UIImage? {
    
    var image: UIImage?

    do {
      if from.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
        let data = try await from.loadItem(forTypeIdentifier: UTType.image.identifier, options: [:])
        
        if let someUri = data as? URL {
          image = UIImage(contentsOfFile: someUri.path())
        } else if let someImage = data as? UIImage {
          image = someImage
        } else {
          image = nil
        }
      }
    } catch {
      
    }

    return image
  }
  
  internal func setupNavBar() {
    navigationItem.title = "Share"
    
    let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    
    self.navigationItem.setLeftBarButton(itemCancel, animated: false)
    self.navigationItem.setRightBarButton(doneAction, animated: false)
    
  }
  
  @objc private func cancelAction() {
    print("cancelled")
  }
  
  @objc private func doneAction() {
    print("done")
  }
}
