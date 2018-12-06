//
//  ProductListingActivityTableViewCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProductListingActivityTableViewCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewProducts: UIImageView!
    @IBOutlet weak var lblDescription: AVLabel!
    @IBOutlet weak var lblTime: AVLabel!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgViewProducts.roundCorners(imgViewProducts.layer.frame.size.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public Methods
    func configureCell(activity: Activity) {
        self.lblDescription.text = "Notification"
    }
}
