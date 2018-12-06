//
//  EditNameCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol EditNameCellDelegate: class {
    func nameChanged(text: String, isFirstName: Bool)
    func tapNexKeyboard(cell: UITableViewCell)
    func textChanged(_ text: String, cell: UITableViewCell)
}

class EditNameCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblFirstName: AVLabel!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var lblLastName: AVLabel!
    @IBOutlet weak var txtFieldLastName: UITextField!
    
    //MARK: - Variables
    var delegate: EditNameCellDelegate?
    
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
        self.txtFieldFirstName.delegate = self
        self.txtFieldLastName.delegate = self
    }
    
    //MARK: - Public Methods
    func configureCell(data: [String: Any]) {
        if let fNameP = data[Constant.keys.kFirstNameP] as? String, let lNameP = data[Constant.keys.kLastNameP] as? String {
            self.lblFirstName.text = fNameP
            self.lblLastName.text = lNameP
        }
        if let fNameV = data[Constant.keys.kFirstNameV] as? String, let lNameV = data[Constant.keys.kLastNameV] as? String {
            self.txtFieldFirstName.text = fNameV
            self.txtFieldLastName.text = lNameV
        }
    }
}

//MARK: - TextField Delegates
extension EditNameCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)

            //CharacterLimitValidation
            if textField == self.txtFieldFirstName, finalText.count == Constant.validation.kFirstNameMax {
                return false
            } else if textField == self.txtFieldLastName, finalText.count == Constant.validation.kLastNameMax {
                return false
            }
            delegate.nameChanged(text: finalText, isFirstName: textField == txtFieldFirstName)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.txtFieldFirstName.isFirstResponder {
            self.txtFieldLastName.becomeFirstResponder()
        } else if let delegate = self.delegate {
            delegate.tapNexKeyboard(cell: self)
        }
        return true
    }
}
