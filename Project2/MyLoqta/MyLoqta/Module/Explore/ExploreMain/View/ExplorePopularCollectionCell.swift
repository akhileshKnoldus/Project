//
//  ExplorePopularCollectionCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ExplorePopularCollectionCellDelegate: class {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell)
}

class ExplorePopularCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewDiscount: UIView!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblPriceBeforeDiscount: UILabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductCurrency: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var seperatorDot: UILabel!
    @IBOutlet weak var viewSoldOut: UIView!
    
    //MARK: - Variables
    weak var delegate: ExplorePopularCollectionCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.seperatorDot.roundCorners(self.seperatorDot.frame.size.width/2)
    }
    
    //MARK: - Private Methods
    private func configureView(isPopular: Bool) {
        self.viewDiscount.roundCorners(Constant.viewCornerRadius)
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
        self.lblPriceBeforeDiscount.isHidden = isPopular == true ? true : false
        self.viewDiscount.isHidden = isPopular == true ? true : false
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: self.lblPriceBeforeDiscount.text ?? "")
    }
        
    //MARK: - Public Methods
    func configureCell(product: Product, isPopular: Bool) {
        self.configureView(isPopular: isPopular)
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
    
    //MARK:- IBAction Methods
    
    @IBAction func tapFavoriteBtn(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didLikeProduct(self)
        }
    }
}
