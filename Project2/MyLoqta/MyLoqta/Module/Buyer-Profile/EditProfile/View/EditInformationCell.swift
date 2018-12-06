//
//  EditInformationCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol EditInformationCellDelegate: class {
    
}

class EditInformationCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var txtFieldInfo: UITextField!
    
    //MARK: - Variables
    var delegate: EditNameCellDelegate?
    var currentIndexPath: IndexPath?

    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.txtFieldInfo.delegate = self
        self.txtFieldInfo.autocorrectionType = .no
    }
    
    //MARK: - Public Methods
    func configureCell(data: [String: Any], indexPath: IndexPath) {
        
        self.currentIndexPath = indexPath
        
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = placeHolder
        }
        if let value = data[Constant.keys.kValue] as? String {
            self.txtFieldInfo.text = value
        }
        
        if indexPath.row == 3 {
            self.txtFieldInfo.returnKeyType = .default
            self.txtFieldInfo.keyboardType = .emailAddress
            self.txtFieldInfo.returnKeyType = .done
            
        } else {
            self.txtFieldInfo.keyboardType = .default
            //self.txtFieldProfile.isSecureTextEntry = true
        }
        if indexPath.row == 4 {
            self.txtFieldInfo.isSecureTextEntry = true
            self.txtFieldInfo.isEnabled = false
        } else {
            self.txtFieldInfo.isSecureTextEntry = false
            self.txtFieldInfo.isEnabled = true
        }
    }
}

//MARK: - TextField Delegates
extension EditInformationCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //WhiteSpace Entered
        if string == " " {
            return false
        }

        //Text Entered for Username
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            var finalText = text.replacingCharacters(in: textRange, with: string)
            if let indexPath = self.currentIndexPath {
                switch indexPath.row {
                case 2:
                    let cs = NSCharacterSet(charactersIn: Constant.acceptableUsernameCharacters).inverted
                    let filtered = string.components(separatedBy: cs).joined(separator: "")
                    if string != filtered {
                        return false
                    }
                    
                    if finalText.isEmpty {
                        finalText = "@"
                    }
                    if finalText.first != "@" {
                        finalText = "@" + finalText
                    }
                    
                    if finalText.count == Constant.validation.kUserNameMax {
                        return false
                    }
                    
                    Threads.performTaskAfterDealy(0.05) {
                        textField.text = finalText
                    }
                    
                case 3:
                    if finalText.count == Constant.validation.kEmailMax {
                        return false
                    }
                default:
                    break
                }
            }
            
            //delegate.informationChanged(text: finalText, cell: self)
            delegate.textChanged(finalText, cell: self)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.delegate {
            delegate.tapNexKeyboard(cell: self)
        }
        return true
    }
}

