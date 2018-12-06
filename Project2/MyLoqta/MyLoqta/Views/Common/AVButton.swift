//
//  AVButton.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 06/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

@IBDesignable
open class AVButton: UIButton {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        Threads.performTaskAfterDealy(0.1) {
            self.drawGradient()
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Threads.performTaskAfterDealy(0.1) {
            self.drawGradient()
        }
    }
    
    @IBInspectable var isButtonActive: Bool = true {
        didSet {
            self.drawGradient()
        }
    }
    
    @IBInspectable var localizeKey: String = "" {
        didSet {
            self.setTitle(NSLocalizedString(localizeKey, comment: ""), for: .normal)
        }
    }
    
    @IBInspectable var conrnerRadius: CGFloat = 0 {
        didSet {
            self.roundCorners(cornerRadius)
        }
    }
    
    private func drawGradient() {
        if let arrayLayer = self.layer.sublayers {
            for layer in arrayLayer {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
        
        if self.isButtonActive {
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.colors = [UIColor.lightOrangeGradientColor.cgColor, UIColor.darkOrangeGradientColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
            self.layer.insertSublayer(gradient, at: 0)
            self.setTitleColor(UIColor.white, for: .normal)
            self.isEnabled = true
        } else {
            self.backgroundColor = UIColor.buttonDisableBgColor
            self.setTitleColor(UIColor.buttonDisableTextColor, for: .normal)
            self.isEnabled = false
        }
        
        
        
    }
    
    private func setRoundedCorners(radius: CGFloat) {
        self.roundCorners(radius)
    }
}
