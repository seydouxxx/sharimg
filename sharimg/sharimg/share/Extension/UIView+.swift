//
//  UIView+.swift
//  share
//
//  Created by Lee Hojun on 2023/01/30.
//

import UIKit

extension UIView {
    
    class GradientLayer: CAGradientLayer { }
    
    @discardableResult func setBackgroundGradient(_ colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0)) -> Self {
        
        self.layer.sublayers?.forEach { sublayer in
            if let gradientLayer = sublayer as? GradientLayer {
                gradientLayer.removeFromSuperlayer()
            }
        }
        
        let gradient = GradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.frame = self.bounds
        gradient.zPosition = -1.0
        
        self.layer.addSublayer(gradient)
        
        return self
    }
    
    
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(bounds: bounds)
//        return renderer.image { rendererContext in
//            drawHierarchy(in: self.frame, afterScreenUpdates: true)
////            layer.render(in: rendererContext.cgContext)
//        }
//    }
    func asImage() -> UIImage? {
        
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIColor {
    
    static func getColor(_ r: Int, _ g: Int, _ b: Int, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
}
