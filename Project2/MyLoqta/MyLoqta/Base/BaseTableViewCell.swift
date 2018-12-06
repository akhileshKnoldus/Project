//
//  BaseTableViewCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
