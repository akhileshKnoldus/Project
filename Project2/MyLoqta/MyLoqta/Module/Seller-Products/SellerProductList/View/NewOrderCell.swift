//
//  NewOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol NewOrderCellDelegate: class{
    func didTapAcceptOrder(_ cell: NewOrderCell)
    func didTapRejectOrder(_ cell: NewOrderCell)
}

class NewOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var lblOrderId: AVLabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnAccept: AVButton!
    @IBOutlet weak var btnReject: UIButton!
    
    //Constraint Outlets
    @IBOutlet weak var constraintStackViewHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate: NewOrderCellDelegate?
    var isPickupOrder: Bool = false
    
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
        self.btnReject.roundCorners(Constant.btnCornerRadius)
        self.addShadow()
    }
    
    private func addShadow() {
        self.viewShadow.layer.shadowColor = UIColor.gray.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewShadow.layer.shadowOpacity = 0.2
        self.viewShadow.layer.shadowRadius = 5.0
        self.viewShadow.layer.cornerRadius = 8
    }
    
    private func setOrderStatus(orderStatus: OrderStatus) {
        let orderStatValue = Helper.getOrderStatsText(orderStatus: orderStatus)
        self.lblOrderStatus.text = orderStatValue.title
        self.lblOrderStatus.textColor = orderStatValue.textColor
        self.viewOrderStatus.backgroundColor = orderStatValue.bgColor
    }
    
    private func setupViewForPickup() {
        if isPickupOrder {
            self.stackView.isHidden = true
            self.constraintStackViewHeight.constant = 0.0
        } else {
            self.stackView.isHidden = false
            self.constraintStackViewHeight.constant = 50.0
            Threads.performTaskAfterDealy(0.2) {
                self.btnAccept.isButtonActive = true
            }
        }
    }
    
    //MARK: - Public Methods
    func configureView(product: Product) {
        self.setupViewForPickup()

        if let orderId = product.orderId {
            self.lblOrderId.text = "\(orderId)"
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus) {
            self.setOrderStatus(orderStatus: status)
        }
        
        self.lblProductName.text = product.itemName
        if let productImage = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
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
            self.lblProductQuantity.text = productQuantity > 1 ? "\(productQuantity) " + "items".localize() : "\(productQuantity) " + "item".localize()
        }
        if let productTotalPrice = product.totalAmount {
            let intPrice = Int(productTotalPrice)
            let usTotalPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usTotalPrice
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapAcceptOrder(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapAcceptOrder(self)
        }
    }
    
    @IBAction func tapRejectOrder(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapRejectOrder(self)
        }
    }
}
