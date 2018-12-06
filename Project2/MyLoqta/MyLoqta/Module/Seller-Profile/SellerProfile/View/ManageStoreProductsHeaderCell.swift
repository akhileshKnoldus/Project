//
//  ManageStoreProductsHeaderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ManageStoreProductsHeaderCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblProductsCount: UILabel!
    @IBOutlet weak var lblRecent: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    
    func configureView(productsCount: Int) {
        if productsCount > 0 {
            self.lblProductsCount.isHidden = false
            self.lblRecent.isHidden = false
            self.lblProductsCount.text = productsCount > 1 ? "\(productsCount) " + "items".localize() : "\(productsCount) " + "item".localize()
        } else {
            self.lblProductsCount.isHidden = true
            self.lblRecent.isHidden = true
        }
    }
}
