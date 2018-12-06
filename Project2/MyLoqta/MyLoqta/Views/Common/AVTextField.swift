//
//  AVTextField.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 07/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AVTextDelegate: UITextFieldDelegate {
    func backspacePressed(textField: UITextField)
}

class AVTextField: UITextField {

    override func deleteBackward() {
        super.deleteBackward()
        guard let avDelete = self.delegate as? AVTextDelegate else { return }
        avDelete.backspacePressed(textField: self)
    }
}
