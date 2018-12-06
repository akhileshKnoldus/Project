//
//  ItemNamePriceCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemNamePriceCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        //["name": name, "price": price]
        if let name = data["name"] as? String {
            self.lblItemName.text = name
        } else {
            self.lblItemName.text = ""
        }
        
        if let price = data["price"] as? Double {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblPrice.text = usPrice
        } else {
            self.lblPrice.text = ""
        }
    }
    
    
    
}
