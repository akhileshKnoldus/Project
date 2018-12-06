//
//  AddNewAddressTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AddNewAddressDelegates: class {
    func didPerformActionOnAddNewAddress()
}

class AddNewAddressTableCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var btnAddNewAddress: UIButton!
    weak var weakDelegate: AddNewAddressDelegates?
    
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
        self.btnAddNewAddress.setTitle("Add new shipping address".localize(), for: .normal)
    }
    
    //MARK:- IBAction
    
    @IBAction func tapAddNewAddressBtn(_ sender: UIButton) {
        if self.weakDelegate != nil {
            self.weakDelegate?.didPerformActionOnAddNewAddress()
        }
    }
}
