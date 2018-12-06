//
//  ShippingCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ShippingCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var lblDetail: AVLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: String]) {
        if let title = data[Constant.keys.kTitle], let value = data[Constant.keys.kValue] {
            self.lblTitle.text = title
            self.lblDetail.text = value
        }
    }
    
}
