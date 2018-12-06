//
//  AddItemCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class AddItemCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblReceivePrice: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    var indexPath: IndexPath?
    weak var delegate: AddItemProtocol?
    
    @IBOutlet weak var lblReceivePriceValue: UILabel!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var txtFieldAddItem: SMFloatingLabelTextField!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtFieldAddItem.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any], indexPath: IndexPath) {
        
        //self.imgViewCheck.isHidden = false
        self.indexPath = indexPath
        
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.txtFieldAddItem.placeholder = placeHolder
        }
        
        if let value = data[Constant.keys.kValue] as? String, !value.isEmpty {            
            self.txtFieldAddItem.text = value
            self.imgViewCheck.isHidden = false
        } else {
            self.imgViewCheck.isHidden = true
            self.txtFieldAddItem.text = ""
        }
        
        if indexPath.section == 2, indexPath.row == 0 {
            self.txtFieldAddItem.keyboardType = .decimalPad
            self.txtFieldAddItem.addInputAccessoryView(title: "Done".localize(), target: self, selector: #selector(tapDone))
            self.imgViewArrow.isHidden = true
            self.lblReceivePrice.isHidden = false
            self.lblReceivePriceValue.isHidden = false
            if let sellerValue = data[Constant.keys.k10Percent] as? String, !sellerValue.isEmpty {
                self.lblReceivePriceValue.text = sellerValue
                self.lblReceivePrice.isHidden = false
                self.lblReceivePriceValue.isHidden = false
            } else {
                self.lblReceivePrice.isHidden = true
                self.lblReceivePriceValue.isHidden = true
            }
            
        } else {
            self.lblReceivePrice.isHidden = true
            self.lblReceivePriceValue.isHidden = true
        }
    }
    
    @objc func tapDone() {
        self.txtFieldAddItem.resignFirstResponder()
    }
}

extension AddItemCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let indexPath = self.indexPath, indexPath.section == 3, indexPath.row == 0, let delegate = self.delegate {
            delegate.pushToShipping(cell: self)
            return false
        }
        
        if let indexPath = self.indexPath, indexPath.section == 1, indexPath.row == 1, let delegate = self.delegate {
            delegate.pushToCondition(cell: self)
            return false
        }
        
        if let indexPath = self.indexPath, indexPath.section == 1, indexPath.row == 0, let delegate = self.delegate {
            delegate.pushToCategory(cell: self)
            return false
        }
        
        if let indexPath = self.indexPath, indexPath.section == 3, indexPath.row == 1, let delegate = self.delegate {
            delegate.pushAddressList(cell: self)
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            self.imgViewCheck.isHidden = false
        } else {
            self.imgViewCheck.isHidden = true
        }
        
        if let currentIndex = self.indexPath, currentIndex.section == 2, currentIndex.row == 0 {
        
            if let text = textField.text, !text.isEmpty {
                self.lblReceivePrice.isHidden = false
                self.lblReceivePriceValue.isHidden = false
            } else {
                self.lblReceivePrice.isHidden = true
                self.lblReceivePriceValue.isHidden = true
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            
            if let currentIndex = self.indexPath, currentIndex.section == 2, currentIndex.row == 0 {
                
                if finalText.isEmpty {
                    self.lblReceivePrice.isHidden = true
                    self.lblReceivePriceValue.isHidden = true
                } else {
                    self.lblReceivePrice.isHidden = false
                    self.lblReceivePriceValue.isHidden = false
                }
                if finalText.utf8.count > 10 {
                    return false
                }
            }
            delegate.updateText(text: finalText, indexPath: indexPath, cell: self)
        }
        return true
    }
}
