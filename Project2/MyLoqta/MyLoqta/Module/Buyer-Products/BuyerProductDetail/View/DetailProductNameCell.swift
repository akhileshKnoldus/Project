//
//  DetailProductNameCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DetailProductNameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLikeCount: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product) {
        if let likeCount = product.likeCount {
            let like = (likeCount > 1) ? "likes".localize() : "like".localize()
            self.lblLikeCount.text = "\(likeCount) \(like)"
        }
        
        if let price = product.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblPrice.text = usPrice
        }
        if let name = product.itemName {
            self.lblName.text = name
        }
        
    }
}
