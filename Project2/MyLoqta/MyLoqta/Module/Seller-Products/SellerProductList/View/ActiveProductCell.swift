//
//  ActiveProductCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ActiveProductCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: AVLabel!
    @IBOutlet weak var lblCurrency: AVLabel!
    @IBOutlet weak var lblAvailable: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    
    //MARK: - Variables
    
    var isDraft: Bool? = false {
        didSet {
            if let status = isDraft, status {
                self.configureViewForDraft()
            }
        }
    }
    
    var addShadow: Bool? = false {
        didSet {
            if let status = addShadow, status {
                self.configureViewForShadow()
            } else {
                self.viewShadow.layer.shadowOpacity = 0.0
            }
        }
    }
    
    var addBorder: Bool? = false {
        didSet {
            if let status = addBorder, status {
                self.configureViewForBorder()
            }
        }
    }
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        Threads.performTaskAfterDealy(0.2) {
            self.imgViewProduct.roundCorners(2.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    func configureCell(product: Product) {
        if let name = product.itemName {
            self.lblProductName.text = name
        }
        if let condition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: condition)
        }
        
        if let shipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: shipping)
        }
        
        if let quantity = product.quantity {
            self.lblProductQuantity.text = "\(quantity)"
        }
        
        if let price = product.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        
        if let array = product.imageUrl, array.count > 0 {
            let imageUrl = array[0]
            self.imgViewProduct.setImage(urlStr: imageUrl, placeHolderImage: nil)
        } else {
            self.imgViewProduct.image = nil
        }
    }
    
    private func configureViewForBorder() {
        self.viewShadow.layer.cornerRadius = 8
        self.viewShadow.layer.borderWidth = 1.0
        self.viewShadow.layer.borderColor = UIColor.borderColor.cgColor
    }
    
    private func configureViewForShadow() {
        self.viewShadow.layer.shadowColor = UIColor.gray.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewShadow.layer.shadowOpacity = 0.2
        self.viewShadow.layer.shadowRadius = 5.0
        self.viewShadow.layer.cornerRadius = 8.0
    }
    
    private func configureViewForDraft() {
        self.lblAvailable.isHidden = true
        self.lblProductQuantity.isHidden = true
    }
}

/*{
 
 enum productShipping: Int {
 case buyerWillPay = 1
 case iWillPay = 2
 case pickup = 3
 case iWillDeliver = 4
 }
 
 
 avenueNo = "";
 blockNo = 17;
 brand = Levis;
 buildingNo = 3;
 categoryId = 7;
 city = Kuwait;
 color = blue;
 condition = 1;
 country = Iraq;
 description = "slim fit";
 discountPercent = 0;
 discountedPrice = 3400;
 imageUrl =             (
 "https://rukminim1.flixcart.com/image/832/832/j7rxpjk0/trouser/k/f/y/30-16p4l23r1012i901-united-colors-of-benetton-original-imaexxjjws7gpy2v.jpeg"
 );
 isDiscount = 0;
 isLike = 0;
 itemId = 1;
 itemName = "Blue Denim";
 likeCount = 1;
 model = "";
 paciNo = "";
 price = 3400;
 quantity = 1;
 sellerId = 2;
 shipping = 1;
 status = 2;
 streetNo = 23;
 tags =             (
 );
 }*/
