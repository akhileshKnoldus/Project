//
//  NotificationViewTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class NotificationViewTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblNotificationType: AVLabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnSwitch.backgroundColor = UIColor.colorWithRGBA(redC: 227.0, greenC: 233.0, blueC: 239.0, alfa: 1.0)
        btnSwitch.layer.cornerRadius = 16.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public Methods
    func configureCell(_ notificationData: NotificationSettingData) {
        self.lblNotificationType.text = notificationData.title
        self.btnSwitch.setOn(notificationData.onOffState, animated: true)
    }
}
