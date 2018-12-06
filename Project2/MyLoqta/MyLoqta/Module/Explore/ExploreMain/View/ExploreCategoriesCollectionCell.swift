//
//  ExploreCategoriesCollectionCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ExploreCategoriesCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgViewCategories: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.imgViewCategories.roundCorners(self.imgViewCategories.frame.size.width/2)
    }
    
    //MARK: - Public Methods
    func configureCell(category: CategoryModel) {
        if let categoryImage = category.imageUrl {
            self.imgViewCategories.setImage(urlStr: categoryImage, placeHolderImage: nil)
        }
        self.lblCategoryName.text = category.name
    }
}
