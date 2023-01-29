//
//  ShareViewController+configuration.swift
//  share
//
//  Created by Lee Hojun on 2023/01/29.
//

import UIKit

extension ShareViewController {
  
  internal func bindViewModel() {
    self.$images.sink { [weak self] images in
      guard let self = self, !images.isEmpty else { return }
      
      // TODO: replace below with code can handle multiple images
      let image = images.compactMap { $0 }.first ?? UIImage(systemName: "person") ?? UIImage()
      self.imageView.image = image
      
      print("DEBUG:size?")
      print(image.size)
      
      self.view.setNeedsLayout()
    }
    .store(in: &self.subscribers)
  }
  
  internal func configureView() {
    
    view.backgroundColor = .black
    
    setupNavBar()
    
    view.addSubview(self.imageView)
    
    self.getContentSources()
  }
  
  internal func layoutView() {
    
    NSLayoutConstraint.activate([
      self.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      self.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      self.imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      self.imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
      
    ])
  }
}
