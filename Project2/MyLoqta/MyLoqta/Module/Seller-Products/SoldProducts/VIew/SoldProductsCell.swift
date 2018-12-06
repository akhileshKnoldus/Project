//
//  SoldProductsCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol SoldProductsCellDelegate: class {
    func didTapFeedback(_ cell: UITableViewCell)
}

class SoldProductsCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblOrderId: AVLabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var imgViewBuyer: UIImageView!
    @IBOutlet weak var lblBuyer: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var btnLeaveFeedback: UIButton!
    
    //MARK: - Variables
    weak var delegate: SoldProductsCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        self.viewOrderStatus.roundCorners(Constant.viewCornerRadius)
        self.imgViewBuyer.roundCorners(self.imgViewBuyer.frame.size.width / 2)
        self.addShadow()
    }
    
    private func addShadow() {
        self.bgView.layer.shadowColor = UIColor.gray.cgColor
        self.bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.bgView.layer.shadowOpacity = 0.2
        self.bgView.layer.shadowRadius = 5.0
        self.bgView.layer.cornerRadius = 8.0
    }
    
    private func setOrderStatus(orderStatus: OrderStatus) {
        let orderStatValue = Helper.getOrderStatsText(orderStatus: orderStatus)
        self.lblOrderStatus.text = orderStatValue.title
        self.lblOrderStatus.textColor = orderStatValue.textColor
        self.viewOrderStatus.backgroundColor = orderStatValue.bgColor
    }
    
    //MARK: - Public Methods
    func configureView(product: Product) {
        if let orderId = product.orderId {
            self.lblOrderId.text = "\(orderId)"
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus) {
            self.setOrderStatus(orderStatus: status)
        }
        if let productImg = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImg, placeHolderImage: nil)
        }
        self.lblProductName.text = product.itemName
        if let productPrice = product.price {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        if let productShipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        if let productQuantity = product.quantity {
            self.lblProductCount.text = productQuantity > 1 ? "\(productQuantity) " + "items".localize() : "\(productQuantity) " + "item".localize()
        }
        if let productTotalPrice = product.totalAmount {
            let intPrice = Int(productTotalPrice)
            let usPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usPrice
        }
        if let buyerImage = product.buyerProfileImage {
            self.imgViewBuyer.setImage(urlStr: buyerImage, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
        self.lblBuyerName.text = product.buyerName
        if let isFeedback = product.isSellerGivenFeedback {
            self.btnLeaveFeedback.isHidden = isFeedback
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapFeedback(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapFeedback(self)
        }
    }
}
