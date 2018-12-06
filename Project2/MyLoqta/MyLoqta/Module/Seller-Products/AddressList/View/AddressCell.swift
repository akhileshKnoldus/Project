//
//  AddressCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class AddressCell: MGSwipeTableCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblTitle: AVLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(address: ShippingAddress) {
        if let title = address.title {
            self.lblTitle.text = title
        }        
        self.lblAddress.text = address.getAddress()
    }
    
}
