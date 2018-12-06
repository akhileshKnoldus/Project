//
//  InTransitOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol InTransitOrderCellDelegate: class {
    func didTapItemDelivered(product: Product)
}

class InTransitOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblOrderId: AVLabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblShippingMethod: UILabel!
    @IBOutlet weak var lblProductQuatity: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    @IBOutlet weak var imgViewBuyer: UIImageView!
    @IBOutlet weak var lblBuyer: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var viewItemDelivered: UIView!
    
    //Constraint Outlets
    @IBOutlet weak var constraintItemDelvrdHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate: InTransitOrderCellDelegate?
    var product: Product?
    var showDriver: Bool? = false {
        didSet {
            if let status = showDriver, status {
                self.configureViewForDriver()
            } else {
                self.configureViewForItemDelivered()
            }
        }
    }
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
        self.viewItemDelivered.layer.cornerRadius = 8.0
    }
    
    private func configureViewForDriver() {
        self.viewItemDelivered.isHidden = true
        self.constraintItemDelvrdHeight.constant = 0.0
        self.lblBuyer.text = "Driver".localize()
        self.btnSendMessage.setTitle("Call to driver".localize(), for: .normal)
    }
    
    private func configureViewForItemDelivered() {
        self.viewItemDelivered.isHidden = false
        self.constraintItemDelvrdHeight.constant = 60.0
        self.lblBuyer.text = "Buyer".localize()
        self.btnSendMessage.setTitle("Send message".localize(), for: .normal)
    }
    
    private func setOrderStatus(orderStatus: OrderStatus) {
        let orderStatValue = Helper.getOrderStatsText(orderStatus: orderStatus)
        self.lblOrderStatus.text = orderStatValue.title
        self.lblOrderStatus.textColor = orderStatValue.textColor
        self.viewOrderStatus.backgroundColor = orderStatValue.bgColor
    }
    
    private func setDriverData(product: Product) {
        if let driverName = product.driverName, !driverName.isEmpty {
            self.lblBuyerName.text = product.driverName
        } else {
            self.lblBuyerName.text = "-"
        }
        if let driverImage = product.driverProfileImage {
            self.imgViewBuyer.setImage(urlStr: driverImage, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
    }
    
    private func setBuyerData(product: Product) {
        self.btnSendMessage.isHidden = true
        self.lblBuyerName.text = product.buyerName
        if let buyerImage = product.buyerProfileImage {
            self.imgViewBuyer.setImage(urlStr: buyerImage, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
    }
    
    //MARK: - Public Methods
    func configureView(product: Product){
        self.product = product
        
        if let orderId = product.orderId {
            self.lblOrderId.text = "\(orderId)"
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus) {
            self.setOrderStatus(orderStatus: status)
        }
        
        self.lblProductName.text = product.itemName
        
        if let price = product.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        
        if let productImage = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        if let productTotalPrice = product.totalPrice {
            let intPrice = Int(productTotalPrice)
            let usTotalPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usTotalPrice
        }
        if let productShipping = product.shipping {
            self.lblShippingMethod.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        if let productQuantity = product.quantity {
            self.lblProductQuatity.text = productQuantity > 1 ? "\(productQuantity) " + "items".localize() : "\(productQuantity) " + "item".localize()
        }
        if let status = showDriver, status {
            self.setDriverData(product: product)
        } else {
            self.setBuyerData(product: product)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapSendMessage(_ sender: UIButton) {
        
    }
    
    @IBAction func tapItemDelivered(_ sender: UIButton) {
        if let delegate = delegate, let prdct = self.product {
            delegate.didTapItemDelivered(product: prdct)
        }
    }
}
