//
//  TrackStatusActivityTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class TrackStatusActivityTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewProducts: UIImageView!
    @IBOutlet weak var lblTime: AVLabel!
    @IBOutlet weak var lblDescription: AVLabel!
    @IBOutlet weak var lblStatus: AVLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewProducts.roundCorners(4.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private Methods
    func getOrderStatsText(orderStatus: OrderStatus) -> (title: String, textColor: UIColor, bgColor: UIColor ){
        switch orderStatus {
        case .newOrder: return ("NEW".localize(), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 1), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 0.3))
            
        case .waitingForPickup: return ("WAITING FOR PICKUP".localize(), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 1), UIColor.colorWithRGBA(redC: 40, greenC: 139, blueC: 255, alfa: 0.3))
            
        case .onTheWay: return ("ON THE WAY".localize(), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 1), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 0.3))
            
        case .delivered: return ("DELIVERED".localize(), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 1), UIColor.colorWithRGBA(redC: 251, greenC: 186, blueC: 0, alfa: 0.3))
            
        case .completed: return ("COMPLETED".localize(), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 1), UIColor.colorWithRGBA(redC: 119, greenC: 213, blueC: 15, alfa: 0.3))
            
        case .cancelledByMerchant: return ("REJECTED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_byCustomer: return ("RETURNED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_onTheWayToSeller: return ("RETURNED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .rejected_recievedByMerchant: return ("RETURNED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
            
        case .cancelled_byAdmin: return ("REJECTED".localize(), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 1), UIColor.colorWithRGBA(redC: 231, greenC: 51, blueC: 49, alfa: 0.3))
        }
    }
    
    //MARK:- Public Methods
    func configureCellItemStatus(activity: Activity) {
        if let productImage = activity.itemImage {
            self.imgViewProducts.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        if let orderId = activity.orderId {
            let statusOrder = "Status of your order with OrderId:".localize()
            let statusChange = "changed to:".localize()
            let finalText = statusOrder + " \(orderId) " + statusChange
            self.lblDescription.text = finalText
        }
        if let status = activity.orderStatus, let orderStatus = OrderStatus(rawValue: status) {
            let orderStatValue = self.getOrderStatsText(orderStatus: orderStatus)
            self.lblStatus.text = orderStatValue.title
            self.lblStatus.textColor = orderStatValue.textColor
            self.lblStatus.backgroundColor = orderStatValue.bgColor
            Threads.performTaskAfterDealy(0.2) {
                self.lblStatus.roundCorners(4.0)
            }
        }
        
        if let notificationTime = activity.createdAt {
            self.lblTime.text = Date.timeSince(notificationTime)
        }
    }
}
