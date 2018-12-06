//
//  ExploreSubCategoryCollectionCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ExploreSubCategoryCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var lblSubCategoryName: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.bgView.roundCorners(Constant.viewCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureDataOnView(subCategory: SubCategoryModel) {
        self.lblSubCategoryName.text = subCategory.name
    }
}
