//
//  SellerCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Cosmos

class SellerCell: BaseTableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var imgViewSeller: UIImageView!
    
    @IBOutlet weak var btnDriver: UIButton!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var viewDriver: UIView!
    @IBOutlet weak var imgViewStar: UIImageView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var lblPlaceHolder: AVLabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    @IBOutlet weak var lblSellerName: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imgViewSeller.makeLayer(color: UIColor.colorWithAlpha(color: 151.0, alfa: 1.0), boarderWidth: 1.0, round: 24.0)
        self.viewDriver.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // Confgure Seller cell for OrderDetailViewC
    func configureSellerCell(orderDetail: Product) {
        self.lblPlaceHolder.text = "Seller".localize()
        self.imgViewCheck.isHidden = false
        self.imgViewArrow.isHidden = true
        self.viewDriver.isHidden = true
        self.viewLine.isHidden = true
        
        if let name = orderDetail.sellerName {
            self.lblSellerName.text = name
        }
        if let imageUrl = orderDetail.sellerProfileImage {
            self.imgViewSeller.setImage(urlStr: imageUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
        
        if let ratingStar = orderDetail.ratingStar {
            self.viewRating.rating = ratingStar
        }
        
        if let reviewCount = orderDetail.ratingCount {
            self.lblReviewCount.text = "(\(reviewCount))"
        } else {
            self.lblReviewCount.text = ""
        }
    }
    
    
    // Configure cell for Buyer in ItemStateViewC
    func configureCell(orderDetail: Product) {
        self.lblPlaceHolder.text = "Buyer".localize()
        self.imgViewCheck.isHidden = true
        self.imgViewArrow.isHidden = true
        self.viewLine.isHidden = false
        
        if let name = orderDetail.buyerName {
            self.lblSellerName.text = name
        }
        
        if let imageUrl = orderDetail.buyerProfileImage {
            self.imgViewSeller.setImage(urlStr: imageUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
        
        if let ratingStar = orderDetail.ratingStar {
            self.viewRating.rating = ratingStar
        }
        
        if let reviewCount = orderDetail.ratingCount {
            self.lblReviewCount.text = "(\(reviewCount))"
        } else {
            self.lblReviewCount.text = ""
        }
    }
    
    
    
    
    // Configure cell for Driver in ItemStateViewC
    func configureDriverCell(driver: [String: Any]) {
        self.lblPlaceHolder.text = "Driver".localize()
        self.imgViewCheck.isHidden = true
        self.imgViewArrow.isHidden = true
        self.lblReviewCount.isHidden = true
        self.viewRating.isHidden = true
        self.lblSellerName.text = ""
        
        self.viewDriver.isHidden = false
        self.btnDriver.setTitle("Call to driver".localize(), for: .normal)
        if let driverName = driver["name"] as? String, !driverName.isEmpty {
            self.lblDriverName.text = driverName
        } else {
            self.lblDriverName.text = "-"
        }
        if let imageUrl = driver["image"] as? String {
            self.imgViewSeller.setImage(urlStr: imageUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
    }
    
}
