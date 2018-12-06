//
//  ActiveOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ActiveOrderCellDelegate: class {
    func didTapTrackOrder(_ cell: UITableViewCell)
}

class ActiveOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblOrderDatePlaceholder: AVLabel!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblOrderDate: AVLabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblTotalPrice: AVLabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var lblQuantityPlaceholder: AVLabel!
    @IBOutlet weak var viewTrackOrder: UIView!
    @IBOutlet weak var lowerSeperator: UIView!
    
    //MARK: - Variables
    weak var delegate: ActiveOrderCellDelegate?
    
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
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
        self.addShadow()
    }
    
    private func addShadow() {
        self.viewBg.layer.shadowColor = UIColor.gray.cgColor
        self.viewBg.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewBg.layer.shadowOpacity = 0.2
        self.viewBg.layer.shadowRadius = 5.0
        self.viewBg.layer.cornerRadius = 8.0
        self.viewTrackOrder.layer.cornerRadius = 8.0
    }
    
    private func setOrderStatus(orderStatus: OrderStatus) {
        let orderStatValue = Helper.getOrderStatsText(orderStatus: orderStatus)
        self.lblOrderStatus.text = orderStatValue.title
        self.lblOrderStatus.textColor = orderStatValue.textColor
        self.viewOrderStatus.backgroundColor = orderStatValue.bgColor
    }
    
    private func setupViewForPickup(product: Product) {
        if let shipping = product.shipping, let shippingType = productShipping(rawValue: shipping), let status = product.orderStatus, let orderStatus = OrderStatus(rawValue: status)  {
            
            if shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery {
                if orderStatus == .onTheWay {
                    self.viewTrackOrder.isHidden = false
                    self.lowerSeperator.isHidden = false
                } else {
                    self.viewTrackOrder.isHidden = true
                    self.lowerSeperator.isHidden = true
                }
            } else {
                self.viewTrackOrder.isHidden = true
                self.lowerSeperator.isHidden = true
            }
        }
    }
    
    //MARK: - Public Methods
    func configureViewForActiveOrder(product: Product) {
        self.setupViewForPickup(product: product)
        if let date = product.orderDate {
            self.lblOrderDatePlaceholder.text = "Order date:".localize()
            let orderDate = date.UTCToLocal(toFormat: "YYYY-MM-dd HH:mm")
            self.lblOrderDate.text = orderDate
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus)  {
            self.setOrderStatus(orderStatus: status)
        }
        if let productImg = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImg, placeHolderImage: nil)
        }
        self.lblProductName.text = product.itemName
        if let productPrice = product.totalAmount {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usPrice
        }
        if let productShipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        self.lblQuantityPlaceholder.isHidden = false
        self.lblProductQuantity.isHidden = false
        if let productQuantity = product.quantity {
            self.lblProductQuantity.text = "\(productQuantity)"
        }
    }
    
    func configureViewForArchivedOrder(product: Product) {
        self.setupViewForPickup(product: product)
        if let orderId = product.orderId {
            self.lblOrderDatePlaceholder.text = "Order ID:".localize()
            self.lblOrderDate.text = "\(orderId)"
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus)  {
            self.setOrderStatus(orderStatus: status)
        }
        if let productImg = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImg, placeHolderImage: nil)
        }
        self.lblProductName.text = product.itemName
        if let productPrice = product.totalAmount {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usPrice
        }
        if let productShipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        self.lblQuantityPlaceholder.isHidden = true
        self.lblProductQuantity.isHidden = true
    }
    
    //MARK: - IBActions
    @IBAction func tapTrackOrder(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapTrackOrder(self)
        }
    }
}
