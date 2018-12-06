//
//  CheckoutTotalAmountTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class CheckoutTotalAmountTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var lblNoOfItems: AVLabel!
    @IBOutlet weak var lblTotalProductPrice: AVLabel!
    @IBOutlet weak var lblTotalPrice: AVLabel!
    @IBOutlet weak var lblTotalShippingPrice: AVLabel!
    @IBOutlet weak var lblShippingCurrency: AVLabel!
    @IBOutlet weak var constWidthShippingCurrency: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(arrCartItems: [CartInfo]) {
        var totalProductPrice = 0
        var totalShippingCharge = 0

        for item in arrCartItems {
            if let productPrice = item.price, let quantity = item.cartQuantity {
                totalProductPrice = totalProductPrice + (productPrice * quantity)
            }
            if let shippingCharge = item.shippingCharge, let quantity = item.cartQuantity {
                totalShippingCharge = totalShippingCharge + (shippingCharge * quantity)
            }
        }
        let usTotalProductPrice = totalProductPrice.withCommas()
        self.lblTotalProductPrice.text = usTotalProductPrice
        if totalShippingCharge == 0 {
            self.lblTotalShippingPrice.text = "Free"
            self.lblShippingCurrency.text = ""
            self.constWidthShippingCurrency.constant = 0
        } else {
            let usShippingCharge = totalShippingCharge.withCommas()
            self.lblTotalShippingPrice.text = usShippingCharge
        }
        let totalAmount = totalProductPrice + totalShippingCharge
        let usTotalAmount = totalAmount.withCommas()
        self.lblTotalPrice.text = usTotalAmount
        let productCount = arrCartItems.count
        self.lblNoOfItems.text = productCount > 1 ? "\(productCount) items" : "\(productCount) item"
    }
}
