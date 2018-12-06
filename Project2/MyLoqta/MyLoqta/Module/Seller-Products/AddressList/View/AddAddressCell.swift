//
//  AddAddressCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class AddAddressCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var btnNewAddress: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnNewAddress.setTitle("Add new shipping address".localize(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
