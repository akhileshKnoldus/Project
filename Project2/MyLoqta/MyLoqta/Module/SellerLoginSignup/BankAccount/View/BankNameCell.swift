//
//  BankNameCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BankNameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var txtFieldBankName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
