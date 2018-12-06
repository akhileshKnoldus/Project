//
//  ArchivedOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol ArchivedOrderCellDelegate: class {
    func didTapFeedback(_ cell: UITableViewCell)
}

class ArchivedOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblOrderId: AVLabel!
    @IBOutlet weak var viewOrderStatus: UIView!
    @IBOutlet weak var lblOrderStatus: AVLabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductCondition: UILabel!
    @IBOutlet weak var lblProductShipping: UILabel!
    @IBOutlet weak var lblProductQuantity: UILabel!
    @IBOutlet weak var viewBuyer: UIView!
    @IBOutlet weak var imgViewBuyer: UIImageView!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var lblBuyerPlaceholder: UILabel!
    
    
    //MARK: - Variables
    weak var delegate: ArchivedOrderCellDelegate?

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
        self.imgViewBuyer.roundCorners(self.imgViewBuyer.frame.size.width / 2)
        self.addShadow()
    }
    
    private func addShadow() {
        self.viewBg.layer.shadowColor = UIColor.gray.cgColor
        self.viewBg.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewBg.layer.shadowOpacity = 0.2
        self.viewBg.layer.shadowRadius = 5.0
        self.viewBg.layer.cornerRadius = 8.0
    }
    
    private func setOrderStatus(orderStatus: OrderStatus) {
        let orderStatValue = Helper.getOrderStatsText(orderStatus: orderStatus)
        self.lblOrderStatus.text = orderStatValue.title
        self.lblOrderStatus.textColor = orderStatValue.textColor
        self.viewOrderStatus.backgroundColor = orderStatValue.bgColor
    }
    
    //MARK: - Public Methods
    func configureView(product: Product) {
        self.lblBuyerPlaceholder.text = "Seller".localize()
        if let date = product.orderDate {
            let orderDate = date.UTCToLocal(toFormat: "YYYY-MM-dd HH:mm")
            self.lblOrderId.text = orderDate
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
        if let sellerImg = product.sellerProfilePic {
            self.imgViewBuyer.setImage(urlStr: sellerImg, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        }
        self.lblBuyerName.text = product.sellerName
    }
    
    //MARK: - IBActions
    @IBAction func tapLeaveFeedback(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapFeedback(self)
        }
    }
}
