//
//  RejectReasonCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class RejectReasonCell: BaseTableViewCell, ReusableView, NibLoadableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblPlaceholder: AVLabel!
    @IBOutlet weak var lblValue: UILabel!
    
    //MARK: - Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureView(placeholder: String, reason: String) {
        self.lblPlaceholder.text = placeholder
        self.lblValue.text = reason
    }
}
