//
//  FollowingActivityTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class FollowingActivityTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblTime: AVLabel!
    @IBOutlet weak var lblDescription: AVLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewProduct.roundCorners(self.imgViewProduct.layer.frame.size.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public Methods
    func configureCellForOrderSuccess(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let orderId = activity.orderId {
            let yourOrder = "Your order has been placed successfully and your order id is".localize()
            let finalText = yourOrder + " \(orderId)."
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForBuyerOrderAccept(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let acceptedSeller = "has been accepted by the seller.".localize()
            let finalText = yourOrder + " \(productName) " + acceptedSeller
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }

    func configureCellForBuyerOrderReject(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let rejectedSeller = "has been rejected by the seller.".localize()
            let finalText = yourOrder + " \(productName) " + rejectedSeller
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForBuyerAdminOrderReject(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let rejectedAdmin = "has been rejected by the admin.".localize()
            let finalText = yourOrder + " \(productName) " + rejectedAdmin
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    
    func configureCellForBuyerOrderAcceptPickup(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let acceptPickup = "has been accepted by the seller and it is ready for pickup.".localize()
            let finalText = yourOrder + " \(productName) " + acceptPickup
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    
    func configureCellForSellerOrderAssignedToDriver(activity: Activity) {
        if let driverImage = activity.driverImage {
            self.imgViewProduct.setImage(urlStr: driverImage, placeHolderImage: nil)
        }
        
        if let driverName = activity.driverName, let orderId = activity.orderId {
            let assignOrder = "is assigned for your order with OrderId:".localize()
            let finalText = driverName + " \(assignOrder) " + "\(orderId)"
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    
    func configureCellForSellerDriverStartedPickup(activity: Activity) {
        if let driverImage = activity.driverImage {
            self.imgViewProduct.setImage(urlStr: driverImage, placeHolderImage: nil)
        }
        
        if let driverName = activity.driverName, let orderId = activity.orderId {
            let collectOrder = "is on the way to collect the order with OrderId:".localize()
            let finalText = driverName + " \(collectOrder) " + "\(orderId)"
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForBuyerDriverDeliveredOrder(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let orderId = activity.orderId {
            let yourOrder = "Your order with OrderId:".localize()
            let deliveredSuccessful = "has been delivered successfully.".localize()
            let finalText = yourOrder + " \(orderId) " + deliveredSuccessful
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForSellerItemBecomesActive(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourItem = "Your item".localize()
            let listNow = "is listed now.".localize()
            let finalText = yourItem + " \(productName) " + listNow
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForBuyerSellerRepliesQuestion(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let placeSuccessful = "has been placed successfully.".localize()
            let finalText = yourOrder + " \(productName) " + placeSuccessful
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForSellerBuyerFollow(activity: Activity) {
        if let buyerImage = activity.buyerImage {
            self.imgViewProduct.setImage(urlStr: buyerImage, placeHolderImage: nil)
        }
        
        if let buyerName = activity.buyerName {
            let startFollow = "started following you.".localize()
            let finalText = "\(buyerName) " + startFollow
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    
    func configureCellForSellerAdminOrderReject(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let productName = activity.itemName {
            let yourOrder = "Your order for item".localize()
            let rejectedAdmin = "has been rejected by the admin.".localize()
            let finalText = yourOrder + " \(productName) " + rejectedAdmin
            self.lblDescription.text = finalText
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
    func configureCell(activity: Activity) {
        self.lblDescription.text = "Notification"
    }
    
}
