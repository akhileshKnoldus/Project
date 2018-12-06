//
//  DetailProductSeller.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Cosmos

class DetailProductSeller: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var btnMessageToSeller: UIButton!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var imgViewSeller: UIImageView!
    @IBOutlet weak var lblSellerTitle: UILabel!
    @IBOutlet weak var imgViewVerified: UIImageView!
    @IBOutlet weak var viewRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Threads.performTaskAfterDealy(0.2) {
            self.imgViewSeller.roundCorners(36.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.lblSellerTitle.text = "Seller".localize()
    }
    
    func configureCell(product: Product)  {
        if let seller = product.sellerDetail {
            if let name = seller.sellerName {
                self.lblSellerName.text = name
            }
            
            if let productCount = seller.totalProducts {
                let product = (productCount > 1) ? "Products".localize() : "Product".localize()
                self.lblProductCount.text = "\(productCount) \(product)"
            }
            
            if let profileUrl = seller.profilePic, !profileUrl.isEmpty {
                self.imgViewSeller.contentMode = .scaleAspectFill
                self.imgViewSeller.setImage(urlStr: profileUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
            } else {
                self.imgViewSeller.contentMode = .center
                self.imgViewSeller.image = #imageLiteral(resourceName: "user_placeholder")
            }
            
            if let approvalStatus = seller.approvalStatus, approvalStatus == sellerStatus.approved.rawValue {
                self.imgViewVerified.isHidden = false
            }
        }
        
        if let ratingCount = product.ratingCount {
            self.lblReviewCount.text = "(\(ratingCount))"
        }
        if let ratingStar = product.ratingStar {
            self.viewRating.rating = ratingStar
        }
    }
    
}
