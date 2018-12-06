//
//  RecentViewedCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class RecentViewedCell: UICollectionViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Threads.performTaskAfterDealy(0.2) {
            self.imgViewProduct.roundCorners(4)
        }
    }
    
    func configureCell(product: Product) {
        if let name = product.itemName {
            self.lblItemName.text = name
        } else {
            self.lblItemName.text = ""
        }
        
        if let price = product.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblPrice.text = usPrice
        } else {
            self.lblPrice.text = ""
        }
        
        if let image = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: image, placeHolderImage: UIImage())
        }
    }

}
