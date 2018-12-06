//
//  ReferralDetailCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ReferralDetailCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblReferralLink: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
