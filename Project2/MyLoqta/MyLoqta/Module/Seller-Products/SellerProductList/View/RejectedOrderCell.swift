//
//  RejectedOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol RejectedOrderCellDelegate: class {
    func didTapPublishAgain(_ cell: RejectedOrderCell)
}

class RejectedOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
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
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var lblRejectReason: UILabel!
    @IBOutlet weak var btnPublishAgain: AVButton!
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblOrderIdPlaceholder: AVLabel!
    
    //MARK: - Variables
    weak var delegate: RejectedOrderCellDelegate?
    
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
        self.viewDescription.roundCorners(Constant.viewCornerRadius)
        self.addShadow()
        self.lblOrderStatus.text = "REJECTED".localize()
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
    func configureView(product: Product){
        self.lblOrderIdPlaceholder.isHidden = false
        self.lblOrderId.isHidden = false
        self.btnPublishAgain.setTitle("Publish again".localize(), for: .normal)
        if let orderId = product.orderId {
            self.lblOrderId.text = "\(orderId)"
        }
        self.lblProductName.text = product.itemName
        
        if let productImage = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productTotalPrice = product.price {
            let intPrice = Int(productTotalPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        if let productShipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus) {
            if status == .rejected_byCustomer {
                self.lblBuyerName.text = product.buyerName
            } else {
                self.lblBuyerName.text = product.sellerName
            }
        }
        self.lblRejectReason.text = product.rejectReason
    }
    
    //RejectedProductView
    func configureViewForRejectedProduct(product: Product){
        self.lblOrderIdPlaceholder.isHidden = true
        self.lblOrderId.isHidden = true
        if let orderId = product.orderId {
            self.lblOrderId.text = "\(orderId)"
        }
        
        if let orderStatus = product.orderStatus, let status = OrderStatus(rawValue: orderStatus) {
            self.setOrderStatus(orderStatus: status)
        }
        self.lblProductName.text = product.itemName
        
        if let arrProductImages = product.imageUrl, arrProductImages.count > 0 {
            self.imgViewProduct.setImage(urlStr: arrProductImages[0], placeHolderImage: nil)
        }
        
        if let productTotalPrice = product.price {
            let intPrice = Int(productTotalPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        if let productShipping = product.shipping {
            self.lblProductShipping.text = Helper.returnShippingTitle(shipping: productShipping)
        }
        if let productCondition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: productCondition)
        }
        self.btnPublishAgain.setTitle("Edit".localize(), for: .normal)
        self.lblBuyerName.text = "Moderator".localize()
        self.lblRejectReason.text = product.rejectReason
    }
    //MARK: - IBActions
    @IBAction func tapPublishAgain(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapPublishAgain(self)
        }
    }
}
