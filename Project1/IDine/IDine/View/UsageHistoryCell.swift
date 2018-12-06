//
//  UsageHistoryCell.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class UsageHistoryCell: UITableViewCell {

    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRefrenceCode: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
