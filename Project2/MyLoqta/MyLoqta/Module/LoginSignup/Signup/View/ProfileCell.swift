//
//  ProfileCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProfileCellDelegate: class {
   
}

class ProfileCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var viewBottomLine: UIView!
    @IBOutlet weak var txtFieldProfile: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    weak var weakDelegate: NameCellDelegate?
    var currentIndexPath : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtFieldProfile.autocorrectionType = .no
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: String], indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.btnEye.isHidden = true
//        self.txtFieldProfile.addInputAccessoryView(title: "Next".localize(), target: self, selector: #selector(tapNext(sender:)))
        if let placeHolder = data[Constant.keys.kTitle]  {
            self.txtFieldProfile.placeholder = placeHolder
        }
        self.txtFieldProfile.text = data[Constant.keys.kValue]
        
        if indexPath.row == 3 {
            self.txtFieldProfile.keyboardType = .emailAddress
            
        } else {
            self.txtFieldProfile.keyboardType = .default
            //self.txtFieldProfile.isSecureTextEntry = true
        }
        if indexPath.row == 4 {
            self.txtFieldProfile.returnKeyType = .done
            self.btnEye.isHidden = false
            self.txtFieldProfile.isSecureTextEntry = true
        } else {
            self.txtFieldProfile.isSecureTextEntry = false
        }
    }
    
    @objc func tapNext(sender: UIButton) {
        if let delegate = self.weakDelegate {
            delegate.tapNexKeyboard(cell: self)
        }
    }
    
    @IBAction func tapShowPassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtFieldProfile.isSecureTextEntry = sender.isSelected
    }
}

extension ProfileCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //WhiteSpace Entered
        if string == " " {
            return false
        }
        
        //Text Entered for Username
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.weakDelegate {
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
                    if finalText.count > Constant.validation.kEmailMax {
                        return false
                    }
                case 4:
                    if finalText.count == Constant.validation.kPasswordMax {
                        return false
                    }
                default:
                    break
                }
            }
            
            delegate.updateProfileData(cell: self, text: finalText)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = self.weakDelegate {
            delegate.tapNexKeyboard(cell: self)
        }
        return true
    }
}
