//
//  UIViewController+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func addLeftButton(image: UIImage, target: UIViewController, action: Selector)  {
        
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(image, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: action, for: .touchUpInside)
        leftButton.contentHorizontalAlignment = .left
        let item = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = item
        
    }
    
    func addRightButton(image: UIImage, target: UIViewController, action: Selector)  {
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(image, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: action, for: .touchUpInside)
        let item = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func addRightButton(title: String, titleColor: UIColor?, font: UIFont?, target: UIViewController, action: Selector) {
        
        let rightButton = UIButton(type: .custom)
        rightButton.setTitle(title, for: .normal)
        if let fontValue = font {
            rightButton.titleLabel?.font = fontValue
        } else {
            rightButton.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        }
        if let colorValue = titleColor {
            rightButton.setTitleColor(colorValue, for: .normal)
        } else {
            rightButton.setTitleColor(UIColor.colorWithAlpha(color: 16, alfa: 1.0), for: .normal)
        }
        rightButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        rightButton.contentHorizontalAlignment = .right
        rightButton.addTarget(self, action: action, for: .touchUpInside)
        let item = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = item
    }
    
    func setNavTitle(title: String) {
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.colorWithAlpha(color: 16.0, alfa: 1.0), NSAttributedStringKey.font: UIFont.font(name: .SFProDisplay, weight: .SemiBold, size: .size_17)]
        self.title = title
    }
}
