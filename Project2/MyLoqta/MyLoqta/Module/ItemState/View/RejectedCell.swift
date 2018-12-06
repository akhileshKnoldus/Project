//
//  RejectedCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class RejectedCell: BaseTableViewCell, NibLoadableView, ReusableView  {

    @IBOutlet weak var lblRejectedDetail: AVLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        if let rejectDetail = data[Constant.keys.kValue] as? String {
            self.lblRejectedDetail.text = rejectDetail
        } else {
            self.lblRejectedDetail.text = ""
        }
    }
    
}
