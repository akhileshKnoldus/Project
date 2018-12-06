//
//  GradientButtonView.swift
//  AppVenture
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class GradientButtonView: UIButton {
    
    @IBInspectable var conrnerRadius: CGFloat = 0 {
        didSet {
            self.roundCorners(cornerRadius)
        }
    }
    
    @IBInspectable var isButtonActive: Bool = true {
        didSet {
            self.drawGradient()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeGradientColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeGradientColor()
    }
    
    private func initializeGradientColor() {
        Threads.performTaskAfterDealy(0.2) {
            self.drawGradient()
        }
    }
    
    private func drawGradient() {
        //self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layer.sublayers = nil
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = self.isButtonActive ? [UIColor.lightOrangeGradientColor.cgColor, UIColor.darkOrangeGradientColor.cgColor] : [UIColor.borderColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
        
    }
}
