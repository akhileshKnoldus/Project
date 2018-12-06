//
//  QuantityCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class QuantityCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var lblQuantityPlaceholder: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    weak var delegate: AddItemProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        if let value = data[Constant.keys.kValue] as? Int {
            self.lblQuantity.text = "\(value)"
        }
        if let title = data[Constant.keys.kTitle] as? String {
            lblQuantityPlaceholder.text = title
        }
        
        if let sellerType = UserSession.sharedSession.getSellerType() {
            if sellerType == .individual {
                self.btnMinus.isHidden = true
                self.btnPlus.isHidden = true
            }
        }
    }
    
    @IBAction func tapMinus(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: false, cell: self)
    }
    
    @IBAction func tapPlush(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: true, cell: self)
    }
}
