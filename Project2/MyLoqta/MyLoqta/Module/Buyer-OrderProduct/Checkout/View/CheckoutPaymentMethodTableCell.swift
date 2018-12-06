//
//  CheckoutPaymentMethodTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol CheckoutPaymentCellDelegates: class {
    func didPerformActionOnTappingWalletBtn(_ sender: UIButton)
}

class CheckoutPaymentMethodTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtFieldCardNumber: UITextField!
    @IBOutlet weak var txtFieldExpiryDate: UITextField!
    @IBOutlet weak var txtFieldCVC: UITextField!
    @IBOutlet weak var viewCreditCard: UIView!
    @IBOutlet weak var viewDebitCard: UIView!
    @IBOutlet weak var lblCreditCard: AVLabel!
    @IBOutlet weak var lblDebitCard: AVLabel!
    @IBOutlet weak var lblWalletBal: AVLabel!
    @IBOutlet weak var btnSelectWalletBal: UIButton!
    
    //MARK:- Variables
    weak var delegate: CheckoutPaymentCellDelegates?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setCardViewForSelection(view: self.viewCreditCard, label: self.lblCreditCard)
        self.setCardViewForDeselection(view: self.viewDebitCard, label: self.lblDebitCard)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:- Private Methods
    func setCardViewForSelection(view: UIView, label: UILabel) {
        view.makeLayer(color: UIColor.appOrangeColor, boarderWidth: 1.0, round: 8)
        view.backgroundColor = UIColor.defaultBgColor
        label.textColor = UIColor.actionBlackColor
    }
    
    func setCardViewForDeselection(view: UIView, label: UILabel) {
        view.makeLayer(color: UIColor.grayBorderColor, boarderWidth: 1.0, round: 8)
        view.backgroundColor = UIColor.white
        label.textColor = UIColor.actionBlackColorWithOpacity
    }
    
    //MARK:- Public Methods
    func configureCell(_ walletBalance: Double) {
        let intWalletBalance = Int(walletBalance)
        let usWalletBalance = intWalletBalance.withCommas()
        self.lblWalletBal.text = usWalletBalance
        self.btnSelectWalletBal.isUserInteractionEnabled = walletBalance <= 0.0 ? false : true
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapSelectCreditCardBtn(_ sender: UIButton) {
        self.setCardViewForSelection(view: self.viewCreditCard, label: self.lblCreditCard)
        self.setCardViewForDeselection(view: self.viewDebitCard, label: self.lblDebitCard)
    }
    
    @IBAction func tapSelectDebitCardBtn(_ sender: UIButton) {
        self.setCardViewForSelection(view: self.viewDebitCard, label: self.lblDebitCard)
        self.setCardViewForDeselection(view: self.viewCreditCard, label: self.lblCreditCard)
    }
    
    @IBAction func tapBtnSelectWalletBal(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingWalletBtn(sender)
        }
    }
}
