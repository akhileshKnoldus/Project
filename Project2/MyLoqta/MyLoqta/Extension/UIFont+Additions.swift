//
//  UIFont+Additions.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 10/31/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import UIKit

enum FontSize: CGFloat {
    case size_10  = 10.0
    case size_11  = 11.0
    case size_12  = 12.0
    case size_13  = 13.0
    case size_14  = 14.0
    case size_15  = 15.0
    case size_16  = 16.0
    case size_17  = 17.0
    case size_19  = 19.0
    case size_20  = 20.0
    case size_21  = 21.0
    case size_22  = 22.0
    case size_31  = 31.0
    case size_34  = 34.0
}

enum FontFamily: String {
    case SFProDisplay = "SFProDisplay"
    case SFProText = "SFProText"
    
    func fontName(wieight: FontWeight)-> String {
        return rawValue + "-" + wieight.rawValue
    }
}

enum FontWeight: String {
    case Black         = "Black"
    case BlackItalic   = "BlackItalic"
    case Bold          = "Bold"
    case BoldItalic    = "BoldItalic"
    case ExtraBold     = "ExtraBold"
    case ExtraBoldItalic  = "ExtraBoldItalic"
    case ExtraLight    = "ExtraLight"
    case ExtraLightItalic = "ExtraLightItalic"
    case Light         = "Light"
    case Italic        = "Italic"
    case LightItalic   = "LightItalic"
    case Medium        = "Medium"
    case MediumItalic  = "MediumItalic"
    case Regular       = "Regular"
    case SemiBold      = "Semibold"
    case SemiBoldItalic = "SemiBoldItalic"
    case Thin          =  "Thin"
    case ThinItalic    = "ThinItalic"
}

extension UIFont {
    
    class func font(name fontName: FontFamily, weight: FontWeight = .Regular, size: FontSize ) -> UIFont{
        var newSize = size.rawValue
        switch Constant.screenWidth {
        case 320.0: newSize = newSize - 1.0
        case 375.0: break
        //case 414.0: newSize = newSize + 2.0
        default: newSize = newSize + 2.0
        }
        let fontFamily = fontName.fontName(wieight: weight)
        if let font = UIFont(name: fontFamily, size: newSize) {
            return font
        } else {
            print("error while getting font")
            return UIFont.systemFont(ofSize: newSize)
        }
    }
}
