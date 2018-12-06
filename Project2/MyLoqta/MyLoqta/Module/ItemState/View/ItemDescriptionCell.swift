//
//  ItemDescriptionCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemDescriptionCell: BaseTableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var lblValue: AVLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        if let title = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = title
        } else {
            self.lblTitle.text = ""
        }
        
        if let value = data[Constant.keys.kValue] as? String {
            self.lblValue.text = value
        } else {
            self.lblValue.text = ""
        }
    }
    
    func configureAddressCell(order: Product, indexPath: IndexPath)  {
        if indexPath.row == 0 {
            self.lblTitle.text = "Delivery".localize()
            if let shipping = order.shipping {
                self.lblValue.text = Helper.returnShippingTitle(shipping: shipping)
            }
            
        } else {
            
            if let shiping = order.shipping {
                if shiping == 3 {
                    self.lblTitle.text = "Item location".localize()
                } else {
                    self.lblTitle.text = "Shipping address".localize()
                }
            } else {
                self.lblTitle.text = "Shipping address".localize()
            }
        
            if let address = order.address {
                self.lblValue.text = address.getDisplayAddress()
            } else {
                self.lblValue.text = ""
            }
            
        }
    }
}
