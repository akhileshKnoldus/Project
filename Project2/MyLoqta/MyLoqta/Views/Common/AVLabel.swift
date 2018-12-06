//
//  AVLabel.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class AVLabel: UILabel {

    @IBInspectable var dynamicFont: Bool = false {
        didSet {
            if self.dynamicFont == true {
                self.updatedFont()
            }
        }
    }
    
    @IBInspectable var top: CGFloat = 0.0
    @IBInspectable var left: CGFloat = 0.0
    @IBInspectable var bottom: CGFloat = 0.0
    @IBInspectable var right: CGFloat = 0.0
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    // Failed to set user defined inspected property on (UILabel) this class is not key value coding-compliant for the key
    @IBInspectable var localizeKey: String = "" {
        didSet {
            self.text = NSLocalizedString(localizeKey, comment: "")
        }
    }
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += top + bottom
            contentSize.width += left + right
            return contentSize
        }
    }

    private func updatedFont() {
        let fontName = self.font.fontName
        var fontSize = self.font.pointSize
        switch UIScreen.main.bounds.size.height {
        case 480.0, 568.0: // iPhone 4s , // iPhone SE
            fontSize = fontSize - 1.0
        case 667.0: // iPhone 8
            break
        case 736.0, 812.0: // iPhone 8+, iPhone X
            fontSize = fontSize + 2
        default:
            break
        }
        if let newFont = UIFont(name: fontName, size: fontSize) {
            self.font = newFont
        }
    }
}
