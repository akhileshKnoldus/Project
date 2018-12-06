//
//  CategoryCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class CategoryCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var imgViewArrow: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCategoryCell(category: CategoryModel) {
        if let name = category.name {
            self.lblTitle.text = name
        }
    }
    
    func configureSubCategoryCell(category: SubCategoryModel) {
        if let name = category.name {
            self.lblTitle.text = name
        }
        self.imgViewArrow.isHidden = true
    }
    
}
