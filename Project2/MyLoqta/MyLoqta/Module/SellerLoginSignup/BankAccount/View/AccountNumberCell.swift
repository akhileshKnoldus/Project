//
//  AccountNumberCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AccountNumberCellDelegate: class {
    func accountNumberEntered(_ text: String)
}

class AccountNumberCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var txtFieldAccountNumber: UITextField!
    
    //MARK: - Variables
    var delegate: AccountNumberCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.txtFieldAccountNumber.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
        self.txtFieldAccountNumber.delegate = self
    }
    
    //MARK: - Selector Methods
    @objc func tapDone() {
        self.txtFieldAccountNumber.resignFirstResponder()
    }
}

extension AccountNumberCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.txtFieldAccountNumber.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //SpecialCharacter Validation
        let cs = NSCharacterSet(charactersIn: Constant.acceptableIBANCharacters).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        if string != filtered {
            return false
        }
        
        //WhiteSpace Entered
        if string == " " {
            return false
        }
        
        if let text = textField.text, let textRange = Range(range, in: text), let accDelegate = self.delegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            //IBAN Count Validation
            if finalText.count > Constant.IBANCount {
                return false
            }
           accDelegate.accountNumberEntered(finalText)
        }
        return true
    }
}
