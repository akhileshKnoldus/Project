//
//  NameCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol NameCellDelegate: class {
    func updateName(text: String, isFirstName: Bool)
    func tapNexKeyboard(cell: UITableViewCell)
    func updateProfileData(cell: UITableViewCell, text: String)
}

class NameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    weak var weakDelegate: NameCellDelegate?
    @IBOutlet weak var viewLineLN: UIView!
    @IBOutlet weak var viewLineFN: UIView!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtFieldFirstName.autocorrectionType = .no
        self.txtFieldLastName.autocorrectionType = .no
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: String]) {
        if let fNameP = data[Constant.keys.kFirstNameP], let lNameP = data[Constant.keys.kLastNameP] {
            self.txtFieldFirstName.placeholder = fNameP
            self.txtFieldLastName.placeholder = lNameP
        }
        
//        self.txtFieldFirstName.addInputAccessoryView(title: "Next".localize(), target: self, selector: #selector(tapNext))
//        self.txtFieldLastName.addInputAccessoryView(title: "Next".localize(), target: self, selector: #selector(tapNext))
    }
    
    @objc func tapNext() {
        
        if self.txtFieldFirstName.isFirstResponder {
            self.txtFieldLastName.becomeFirstResponder()
        } else if let delegate = self.weakDelegate {
            delegate.tapNexKeyboard(cell: self)
        }
    }
}

extension NameCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtFieldFirstName {
            if string == " " {
                return false
            }
        }
        
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.weakDelegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            
            //CharacterLimitValidation
            if textField == self.txtFieldFirstName,finalText.count > Constant.validation.kFirstNameMax {
                return false
            } else if textField == self.txtFieldLastName, finalText.count > Constant.validation.kLastNameMax {
                return false
            }
            delegate.updateName(text: finalText, isFirstName: textField == txtFieldFirstName)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.txtFieldFirstName.isFirstResponder {
            self.txtFieldLastName.becomeFirstResponder()
        } else if let delegate = self.weakDelegate {
            delegate.tapNexKeyboard(cell: self)
        }
        return true
    }
}
