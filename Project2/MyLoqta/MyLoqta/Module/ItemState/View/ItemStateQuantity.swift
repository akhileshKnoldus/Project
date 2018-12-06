//
//  ItemStateQuantity.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemStateQuantity: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblPrice: AVLabel!
    @IBOutlet weak var lblItemCount: AVLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Product) {
        if let quantity = order.quantity {
            let quantityStr = (quantity > 1 ) ? "items".localize() : "item".localize()
            self.lblItemCount.text = "\(quantity) \(quantityStr)"
        } else {
            self.lblItemCount.text = ""
        }
        
        if let price = order.totalAmount {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblPrice.text = usPrice
        } else {
            self.lblPrice.text = ""
        }
    }
    
}
