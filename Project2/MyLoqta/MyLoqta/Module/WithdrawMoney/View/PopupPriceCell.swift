//
//  PopupPriceCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol PopupPriceCellDelegate: class {
    func didSelectTransferMethod(isCheque: Bool)
    func didEnterWithdrawAmount(amount: String)
}

class PopupPriceCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnCheque: UIButton!
    @IBOutlet weak var btnWireTransfer: UIButton!
    @IBOutlet weak var txtFieldAmount: SMFloatingLabelTextField!
    
    //MARK: - Variables
    weak var delegate: PopupPriceCellDelegate?

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
        self.txtFieldAmount.delegate = self
        self.txtFieldAmount.placeholder = "Please enter amount to withdrawal (KD)".localize()
        self.btnCheque.isSelected = false
        self.btnWireTransfer.isSelected = true
        self.txtFieldAmount.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
    }
    
    //MARK: - Selector Methods
    @objc func tapDone() {
        self.txtFieldAmount.resignFirstResponder()
    }
    
    //MARK: - IBActions
    @IBAction func tapChequeWithdraw(_ sender: UIButton) {
        self.btnCheque.isSelected = true
        self.btnWireTransfer.isSelected = false
        if let delegate = delegate {
            delegate.didSelectTransferMethod(isCheque: true)
        }
    }
    
    @IBAction func tapTextField(_ sender: UIButton) {
        self.txtFieldAmount.becomeFirstResponder()
    }
    
    @IBAction func tapWireWithdraw(_ sender: UIButton) {
        self.btnCheque.isSelected = false
        self.btnWireTransfer.isSelected = true
        if let delegate = delegate {
            delegate.didSelectTransferMethod(isCheque: false)
        }
    }
}

//MARK: - UITextFieldDelegate
extension PopupPriceCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            let amountText = text.replacingCharacters(in: textRange, with: string)
            if amountText.count > 0 {
                delegate.didEnterWithdrawAmount(amount: amountText)
            } else {
                delegate.didEnterWithdrawAmount(amount: "0")
            }
        }
        return true
    }
}
