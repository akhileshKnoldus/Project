//
//  LocationCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class LocationCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblPlaceHolder: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    
    var textCount = 0 {
        didSet {
            if self.textCount > 0 {
                self.imgViewCheck.isHidden = false
                self.lblPlaceHolder.isHidden = false
            } else {
                self.imgViewCheck.isHidden = true
                self.lblPlaceHolder.isHidden = true
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
    
    func configureCell(data: [String: Any]) {
        
        if let placheHolder = data[Constant.keys.kTitle] as? String {
            self.lblDetail.text = placheHolder
            self.lblDetail.textColor = UIColor.colorWithAlpha(color: 166, alfa: 0.8)
        }
        
        if let value = data[Constant.keys.kValue] as? String, !value.isEmpty {
            self.lblDetail.text = value
            self.lblDetail.textColor = UIColor.colorWithAlpha(color: 116, alfa: 1.0)
            textCount = value.utf8.count
        }
    }
    
}
