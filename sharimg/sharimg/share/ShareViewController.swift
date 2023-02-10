//
//  ShareViewController.swift
//  share
//
//  Created by Lee Hojun on 2023/01/29.
//

import UIKit
import Social

import Combine
import SnapKit


final class ShareViewController: UIViewController {
  
  // configurations : TODO: replace properties from userDefaults

  var canvasVerticalPadding: CGFloat = 40
  var canvasHorizontalPadding: CGFloat = 50
  var imageCornerRadius: CGFloat = 10
  
  // ----
  
  @Published var images: [UIImage] = []
  @Published var currentImage: UIImage?
  
  // saved constraints to resize canvasSize
  var canvasWidth: Constraint?
  var canvasHeight: Constraint?
  
  lazy var containerView: UIView = {
    let view = UIView()
    
    return view
  }()
  
  lazy var canvasView: UIView = {
    let view = UIView()
    
    view.backgroundColor = .systemBlue
    
    return view
  }()
  
  lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    
    return imageView
  }()
  
  lazy var controlAreaView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    
    return view
  }()
  
  lazy var configureButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
    
    return button
  }()
  
  internal var subscribers = Set<AnyCancellable>()
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.bindViewModel()
    self.configureView()
    self.layoutView()
  }
  
}
