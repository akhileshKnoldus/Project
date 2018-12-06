//
//  ProfileNameCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProfileNameCellDelegate: class {
    func textChanged(_ text: String)
}

class ProfileNameCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var txtFieldInfo: UITextField!
    @IBOutlet weak var imgViewArrow: UIImageView!
    
    //MARK: - Variables
    var delegate: ProfileNameCellDelegate?
    var nameDelegate: EditNameCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.txtFieldInfo.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
        self.txtFieldInfo.delegate = self
    }
    
    //MARK: - Selector Methods
    @objc func tapDone() {
        self.txtFieldInfo.resignFirstResponder()
    }
}

//MARK: - TextField Delegates
extension ProfileNameCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = (textField.text as NSString?)?.replacingCharacters(in: range, with: string){
            if let delegate = delegate {
                delegate.textChanged(str)
            }
            if let nameDelegate = nameDelegate {
                nameDelegate.textChanged(str, cell: self)
            }
        }
        return true
    }
}
