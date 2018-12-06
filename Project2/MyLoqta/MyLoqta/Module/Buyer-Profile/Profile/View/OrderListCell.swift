//
//  OrderListCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderListCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblOrderIdPlaceholder: AVLabel!
    @IBOutlet weak var lblOrderId: AVLabel!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductPrice: AVLabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var viewTrackOrder: UIView!
    
    @IBOutlet weak var btntrackOrder: UIButton!
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.viewOrderStatus.roundCorners(Constant.viewCornerRadius)
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
        if let productPrice = product.totalAmount {
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
            self.lblProductQuantity.text = "\(productQuantity)"
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapTrackOrder(_ sender: UIButton) {
        
    }
}
