//
//  ItemPriceCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemPriceCell: BaseTableViewCell, NibLoadableView, ReusableView { 

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblShippingPrice: UILabel!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblShippingCurrency: UILabel!
    
    //Constraint Outlets
    @IBOutlet weak var constraintCurrencyWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Product) {
        if let itemCount = order.quantity {
            let itemStr = itemCount > 1 ? "items".localize() : "item".localize()
            self.lblItemCount.text = "\(itemCount) \(itemStr)"
            
            if let totalPrice = order.totalPrice {
                let intTotalPrice = Int(totalPrice)
                let usTotalPrice = intTotalPrice.withCommas()
                self.lblPrice.text = usTotalPrice
            }
//            let finalPrice = Double(itemCount) * price
//            self.lblPrice.text = "\(Int(finalPrice))"
            
            if let shippingPrice = order.shippingCharge {
                if shippingPrice == 0 {
                    self.lblShippingPrice.text = "Free"
                    self.lblShippingCurrency.text = ""
                    self.constraintCurrencyWidth.constant = 0
                } else {
                    let intShippingPrice = Int(shippingPrice)
                    let usShippingPrice = intShippingPrice.withCommas()
                    self.lblShippingPrice.text = usShippingPrice
                }
            }
            if let totalAmount = order.totalAmount {
                let intAmount = Int(totalAmount)
                let usAmount = intAmount.withCommas()
                self.lblTotal.text = usAmount
            }
        }
    }
    
}
