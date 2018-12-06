//
//  ManageStoreReviewHeaderTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Cosmos

class ManageStoreReviewHeaderTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var lblItemReviews: AVLabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var lblNumOfReviews: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureView(ratingStar: Double, ratingCount: Int) {
        if ratingCount == 0 {
           self.lblItemReviews.isHidden = true
            self.viewRating.isHidden = true
            self.lblNumOfReviews.isHidden = true
        } else {
            self.lblItemReviews.isHidden = false
            self.viewRating.isHidden = false
            self.lblNumOfReviews.isHidden = false
            self.viewRating.rating = ratingStar
            self.lblNumOfReviews.text = "(\(ratingCount))"
        }
    }
}
