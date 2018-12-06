//
//  AddNewAddressCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AddAddressProtocol: class {
    func updateText(text: String, cell: UITableViewCell)
    func tapNexKeyboard(cell: UITableViewCell)
}

class AddNewAddressCell: BaseTableViewCell, NibLoadableView, ReusableView {

    var indexPath: IndexPath?
    weak var delegate: AddAddressProtocol?
    @IBOutlet weak var txtFieldAddress: SMFloatingLabelTextField!
    @IBOutlet weak var imgViewArrow: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: Address, indexPath: IndexPath) {
        
        self.txtFieldAddress.text = data.value
       
        self.indexPath = indexPath
        self.txtFieldAddress.placeholder = data.title
        let row = indexPath.row
        if row == 1 || row == 2 {
            self.imgViewArrow.isHidden = false
            self.txtFieldAddress.isUserInteractionEnabled = false
        } else {
            self.imgViewArrow.isHidden = true
            self.txtFieldAddress.isUserInteractionEnabled = true
        }
        
        if row == 0 || row == 4 {
            txtFieldAddress.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone(sender:)), target: self)
        }
        
        if row == 3 || row == 5 || row == 6 || row == 7 {
            self.txtFieldAddress.keyboardType = .numberPad
            txtFieldAddress.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone(sender:)), target: self)
        } else if row == 0 || row == 1 || row == 2 || row == 4 {
            self.txtFieldAddress.returnKeyType = .next
        } else {
            self.txtFieldAddress.keyboardType = .default
        }
    }
    
    func configureCellForBankInfo(title: String, value: String) {
        self.imgViewArrow.isHidden = true
        self.txtFieldAddress.isUserInteractionEnabled = false
        self.txtFieldAddress.placeholder = title
        self.txtFieldAddress.text = value
    }
    
    @objc func tapDone(sender: UITextField) {
        self.txtFieldAddress.resignFirstResponder()
    }
}

extension AddNewAddressCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.delegate {
            delegate.tapNexKeyboard(cell: self)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            delegate.updateText(text: finalText, cell: self)
        }
        return true
    }
}
