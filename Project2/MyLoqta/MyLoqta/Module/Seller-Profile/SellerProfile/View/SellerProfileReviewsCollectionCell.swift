//
//  SellerProfileReviewsCollectionCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerProfileReviewsCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblReviewerName: AVLabel!
    @IBOutlet weak var lblReviewTime: AVLabel!
    @IBOutlet weak var lblReviewDesc: AVLabel!
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblItemName: AVLabel!
    @IBOutlet weak var lblItemStatus: AVLabel!
    @IBOutlet weak var lblTypeOfDelivery: AVLabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.viewContainer.roundCorners(Constant.btnCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureCell() {
        
    }
}
