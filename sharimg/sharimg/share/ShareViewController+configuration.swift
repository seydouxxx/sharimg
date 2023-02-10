//
//  ShareViewController+configuration.swift
//  share
//
//  Created by Lee Hojun on 2023/01/29.
//

import UIKit
import SnapKit

extension ShareViewController {
  
  internal func bindViewModel() {
    self.$images.sink { [weak self] images in
      guard let self = self, !images.isEmpty else { return }
      
      self.currentImage = images.compactMap { $0 }.first
      
    }
    .store(in: &self.subscribers)
    
    self.$currentImage.sink { [weak self] image in
      
      guard
        let self = self,
          let image = image
      else { return }
      
      // and trigger to update canvas layout constraints
      
      // set this image to imageview
      self.imageView.image = image
      self.setCanvasSize()
      
    }
    .store(in: &self.subscribers)
  }
  
  
  internal func configureView() {
    
    view.backgroundColor = .black
    
    self.setupNavBar()
    
    view.addSubview(self.containerView)
    view.addSubview(self.controlAreaView)

    self.containerView.addSubview(self.canvasView)
    self.canvasView.addSubview(self.imageView)

    self.controlAreaView.addArrangedSubview(self.configureButton)
    
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.pinch(_:)))
    self.canvasView.addGestureRecognizer(pinchGesture)
    
    self.getContentSources()
  }
  
  internal func setupNavBar() {
    
    let itemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelAction))
    let doneAction = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
    
    self.navigationItem.setLeftBarButton(itemCancel, animated: false)
    self.navigationItem.setRightBarButton(doneAction, animated: false)
  }
  
  internal func layoutView() {
    
    self.containerView.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      $0.bottom.equalTo(self.controlAreaView.snp.top)
    }
    
    let controllerAreaViewHeight: CGFloat = 50
    self.controlAreaView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.height.equalTo(controllerAreaViewHeight)
    }

    print("constraint set")
    self.canvasView.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
      self.canvasWidth = $0.width.equalToSuperview().constraint
      self.canvasHeight = $0.height.equalToSuperview().constraint
    }
    
    self.imageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalToSuperview()
      $0.width.equalToSuperview().offset(-self.canvasHorizontalPadding * 2)
      $0.height.equalToSuperview().offset(-self.canvasVerticalPadding * 2)
    }
    
    
    self.configureButton.snp.makeConstraints {
      $0.height.equalToSuperview()
      $0.width.equalTo(controllerAreaViewHeight)
    }
    
    let buttonImageWidth: CGFloat = 30
    self.configureButton.imageView?.snp.makeConstraints {
      $0.height.width.equalTo(buttonImageWidth)
    }
  }
  
  internal func setCanvasSize() {
    
//    guard let image = self.currentImage else { return }
    
//    self.canvasView.snp.makeConstraints {
//      $0.centerY.centerX.equalToSuperview()
//      self.canvasWidth = $0.width.equalToSuperview().constraint
//      self.canvasHeight = $0.height.equalToSuperview().constraint
//    }
    
    
    
    print("2323232")
    self.canvasView.snp.remakeConstraints {
      $0.centerY.centerX.equalToSuperview()
      self.canvasWidth = $0.width.equalTo(500).constraint
      self.canvasHeight = $0.height.equalTo(500).constraint
//      self.canvasWidth = $0.width
    }
    
    self.view.layoutIfNeeded()
    self.drawGradient()
  }
  
  internal func drawGradient() {
    
    self.canvasView
      .setBackgroundGradient([
      UIColor.getColor(251, 170, 123),
      UIColor.getColor(255, 207, 150)
      ], locations: [0.0, 1.0], startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
    
    self.view.layoutIfNeeded()
  }
}
