//
//  DriverCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DriverCell: BaseTableViewCell, NibLoadableView, ReusableView { 

    @IBOutlet weak var imgViewDriver: UIImageView!
    @IBOutlet weak var lblDriverName: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewDriver.roundCorners(self.imgViewDriver.frame.size.width/2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureDriverCell(data: [String: Any]) {
        //["name": driverName, "image": driverImage]
        if let name = data["name"] as? String, !name.isEmpty {
            self.lblDriverName.text = name
        } else {
            self.lblDriverName.text = "-"
        }
        
        if let imageUrl = data["image"] as? String {
            self.imgViewDriver.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
        }
    }
    
}
