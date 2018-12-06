//
//  EditPhoneCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol EditPhoneCellDelegate: class {
    func phoneNumberChanged(_ phone: String)
    func changeButtonTapped(_ cell: EditPhoneCell)
}

class EditPhoneCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var txtFieldInfo: UITextField!
    
    //MARK: - Variables
    var delegate: EditPhoneCellDelegate?
    
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
        self.txtFieldInfo.isEnabled = false
    }
    
    //MARK: - Public Methods
    func configureCell(data: [String: Any]) {
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = placeHolder
        }
        if let value = data[Constant.keys.kValue] as? String {
            self.txtFieldInfo.text = value
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapChange(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.changeButtonTapped(self)
        }
    }
}

//MARK: - TextField Delegates
extension EditPhoneCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), let delegate = delegate {
            delegate.phoneNumberChanged(str)
        }
        return true
    }
}

