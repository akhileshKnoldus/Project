//
//  OrderIdDateCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 08/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderIdDateCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblStatus: AVLabel!
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblProductId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        //"orderId": orderId, "date": dateStr
        if let orderId = data["orderId"] as? Int {
            self.lblOrderId.text = "\(orderId)"
        } else {
            self.lblOrderId.text = ""
        }
        
        if let date = data["date"] as? String {
            let orderDate = date.UTCToLocal(toFormat: "YYYY-MM-dd HH:mm")
            self.lblOrderDate.text = orderDate
        } else {
            self.lblOrderDate.text = ""
        }
        
        if let itemId = data["itemId"] as? Int {
            self.lblProductId.text = "\(itemId)"
        }
        
        if let orderStatus = data["orderStatus"] as? OrderStatus {
            let orderStatValue = self.getOrderStatsText(orderStatus: orderStatus)
            self.lblStatus.text = orderStatValue.title
            self.lblStatus.textColor = orderStatValue.textColor
            self.lblStatus.backgroundColor = orderStatValue.bgColor
            Threads.performTaskAfterDealy(0.2) {
                self.lblStatus.roundCorners(4.0)
            }
        }
    }
   
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
    
}
