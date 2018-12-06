//
//  DetailProductShipping.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol UpdateShippingTypeDelegate: class {
    func didPerformActionOnTappingOnHomeDelivery(selectedIndex: Int)
}

class DetailProductShipping: BaseTableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var lblFirst: AVLabel!
    @IBOutlet weak var lblSecond: AVLabel!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
   // @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var lblCity: UILabel!
   // @IBOutlet weak var lblDeliveryType: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    
    weak var delegate: UpdateShippingTypeDelegate?
    
    var selectedIndex: Int = 1 {
        didSet {
            if selectedIndex == 1 {
                self.lblFirst.makeLayer(color: UIColor.appOrangeColor, boarderWidth: 1.0, round: 4.0)
                self.lblSecond.makeLayer(color: .clear, boarderWidth: 0, round: 0)
            } else {
                self.lblSecond.makeLayer(color: UIColor.appOrangeColor, boarderWidth: 1.0, round: 4.0)
                self.lblFirst.makeLayer(color: .clear, boarderWidth: 0, round: 0)
            }
        }
    }
    
    var isPickup: Bool = false {
        didSet {
            if isPickup {
                self.lblSecond.isHidden = false
                self.btnSecond.isHidden = false
            } else {
                self.lblSecond.isHidden = true
                self.btnSecond.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(product: Product) {
        self.lblShipping.text = "Delivery".localize()
        if let city = product.city {
            self.lblCity.text = "from " + city
        }
        
        if let shippingType = product.shipping {
            self.lblFirst.text = UserSession.sharedSession.getShippingType(intValue: shippingType)
            selectedIndex = 1
            isPickup = (shippingType == 3)
            if isPickup {
                self.lblSecond.text = "Home Delivery".localize()
            }
        }
    }
    
    @IBAction func tapFirst(_ sender: Any) {
        selectedIndex = 1
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingOnHomeDelivery(selectedIndex: self.selectedIndex)
        }
    }
    
    @IBAction func tapSecond(_ sender: Any) {
        selectedIndex = 2
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingOnHomeDelivery(selectedIndex: self.selectedIndex)
        }
    }
    
}


/*
 enum ShippingType: String {
 case buyerWillPay = "Buyer will pay"
 case iWillPay = "I will pay"
 case pickUp = "Pickup"
 case iWillDelivery = "I will deliver"
 
 var intValue: Int {
 switch self {
 case .buyerWillPay: return 1
 case .iWillPay: return 2
 case .pickUp: return 3
 case .iWillDelivery: return 4
 }
 }
 }
 */
