//
//  PromoteCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class PromoteCell: BaseTableViewCell, NibLoadableView, ReusableView {

    weak var delegate: AddItemProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func tapPromote(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.tapButton(actionType: .promote)
    }
    
}
