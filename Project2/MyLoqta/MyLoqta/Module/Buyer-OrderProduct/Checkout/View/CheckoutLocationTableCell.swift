//
//  CheckoutLocationTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class CheckoutLocationTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblLocation: AVLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(address: AddressInfo) {
        var sellerAddress = ""
        if let city = address.city, !city.isEmpty {
            sellerAddress = "City".localize() + ":" + city
        }
        if let block = address.blockNo, !block.isEmpty {
            sellerAddress = sellerAddress + ", " + "Block".localize() + ":" + block
        }
        if let street = address.street, !street.isEmpty {
            sellerAddress = sellerAddress + ", " + "Street".localize() + ":" + street
        }
        if let avenue = address.avenueNo, !avenue.isEmpty {
            sellerAddress = sellerAddress + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = address.buildingNo, !building.isEmpty {
            sellerAddress = sellerAddress + ", " + "Building No.".localize() + ":" + building
        }
        self.lblLocation.text = sellerAddress
    }
}
