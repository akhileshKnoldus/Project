//
//  RateTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Cosmos

protocol RateTableCellDelegate: class {
    
}

class RateTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var viewStarRating: CosmosView!
    
    //MARK: - Variables
    weak var delegate: RateTableCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureView(data: [String: Any]) {
        if let placeholder = data[Constant.keys.kTitle] as? String {
            self.lblPlaceholder.text = placeholder
        }
        if let ratingValue = data[Constant.keys.kValue] as? Double {
            self.viewStarRating.rating = ratingValue
        }
    }
}
