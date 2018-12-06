//
//  AVView.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 07/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

@IBDesignable
open class AVView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return self.layer.borderWidth }
        set { self.layer.borderWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                self.layer.borderColor = color.cgColor
            } else {
                self.layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get { return self.layer.shadowRadius }
        set { self.layer.shadowRadius = newValue }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get { return self.layer.shadowOpacity }
        set { self.layer.shadowOpacity = newValue }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    public func drawGradient() {
        if let arrayLayer = self.layer.sublayers {
            for layer in arrayLayer {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = [UIColor.lightOrangeViewGradientColor.cgColor, UIColor.darkOrangeViewGradientColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func drawGradientWithRGB(startColor: UIColor, endColor: UIColor) {
        if let arrayLayer = self.layer.sublayers {
            for layer in arrayLayer {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func drawGradientWith(startColor: String, endColor: String) {
        if let arrayLayer = self.layer.sublayers {
            for layer in arrayLayer {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        let startGradientColor = UIColor.colorWith(hexString: startColor)
        let endGradientColor = UIColor.colorWith(hexString: endColor)
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [startGradientColor.cgColor, endGradientColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
