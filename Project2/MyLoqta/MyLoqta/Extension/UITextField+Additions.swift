//
//  UITextField+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension UITextField {
    
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: 44.0))
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    /*
    func addNextInputAccessoryView(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: 44.0))
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }*/
}

extension UITextView {
    
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: Constant.screenWidth, height: 44.0))
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
}
