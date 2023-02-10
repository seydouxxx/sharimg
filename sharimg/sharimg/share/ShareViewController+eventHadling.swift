//
//  ShareViewController+eventHadling.swift
//  share
//
//  Created by Lee Hojun on 2023/01/29.
//

import UIKit
import UniformTypeIdentifiers

extension ShareViewController {
  
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
    Task {
      var images: [UIImage?] = []
      for provider in providers {
        try await images.append(_convertSourceToImage(provider))
      }
      self.images = images.compactMap { $0 }
    }
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
  
  @objc internal func cancelAction() {
    self.extensionContext?.completeRequest(returningItems: nil)
  }
  
  @objc internal func doneAction() {
    
    let activityViewController = UIActivityViewController(activityItems: [self.canvasView.asImage() ?? UIImage()], applicationActivities: [])
    self.present(activityViewController, animated: true)
//    self.extensionContext?.completeRequest(returningItems: nil)
  }
  
  @objc internal func pinch(_ gesture: UIPinchGestureRecognizer) {
    
    let maxHeight: CGFloat = self.canvasView.frame.height
    let maxWidth: CGFloat = self.canvasView.frame.width
    
    let scaledWidth: CGFloat = self.imageView.frame.width * gesture.scale
    let scaledHeight: CGFloat = self.imageView.frame.height * gesture.scale
    
    DispatchQueue.main.async {
      if !(scaledWidth > maxWidth || scaledHeight > maxHeight) {
        self.imageView.transform = self.imageView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        print(self.imageView.frame)
        gesture.scale = 1
      }
    }
  }
  
  
}

