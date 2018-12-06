//
//  ForYouCollectionCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/11/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ForYouCollectionCellDelegate: class {
    func didLikeProduct(_ cell: ForYouCollectionCell)
}

class ForYouCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var seperatorDot: UILabel!
    @IBOutlet weak var viewSoldOut: UIView!
    
    //MARK: - Variables
    weak var delegate: ForYouCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureCell(product: Product) {
        if let productImage = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let likeCount = product.likeCount {
            self.lblLikeCount.text = likeCount > 1 ? "\(likeCount) " + "likes".localize() : "\(likeCount) " + "like".localize()
        }
        
        self.lblProductName.text = product.itemName
        
        if let condition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: condition)
        }
        
        if let shipping = product.shipping, let productShipping = productShipping(rawValue: shipping), (productShipping == .iWillPay || productShipping == .iWillDeliver) {
            self.lblProductShipping.text = "Free delivery".localize()
            self.seperatorDot.isHidden = false
        } else {
            self.lblProductShipping.text = ""
            self.seperatorDot.isHidden = true
        }
        
        if let productPrice = product.price {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        
        if let productLiked = product.isLike {
            self.btnLike.isSelected = productLiked
        }
        
        if let isAvailable = product.isAvailable {
            if isAvailable == true {
                self.viewSoldOut.isHidden = true
            } else {
                self.viewSoldOut.isHidden = false
            }
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func tapBtnFavorite(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didLikeProduct(self)
        }
    }
}
