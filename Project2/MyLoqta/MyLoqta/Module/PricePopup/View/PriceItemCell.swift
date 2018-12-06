//
//  PriceItemCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 16/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class PriceItemCell: BaseTableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var imgViewProduct: UIImageView!
    
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
    
    func configureCell(product: Product) {
        if let imageUrl = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
            self.imgViewProduct.roundCorners(4)
        } else if let array = product.imageUrl, array.count > 0 {
            let imageUrl = array[0]
            self.imgViewProduct.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
            self.imgViewProduct.roundCorners(4)
            
        }
        
        if let name = product.itemName {
            self.lblItemName.text = name
        }
        
        if let price = product.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblPrice.text = usPrice
        }
    
    }
    
}
