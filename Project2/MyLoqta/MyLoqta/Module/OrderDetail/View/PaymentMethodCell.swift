//
//  PaymentMethodCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class PaymentMethodCell: BaseTableViewCell, NibLoadableView, ReusableView { 

    @IBOutlet weak var lblCardNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Product) {
        
        //if let carNumber = order.card {
        //    self.
        //}
    }
    
}
