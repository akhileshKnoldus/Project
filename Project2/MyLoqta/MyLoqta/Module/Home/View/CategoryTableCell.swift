//
//  CategoryTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/11/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol CategoryTableCellDelegate: class {
    func didTapSeeAllCategory()
}

class CategoryTableCell: BaseTableViewCell, ReusableView, NibLoadableView  {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewCategory: UIImageView!
    @IBOutlet weak var lblCategoryName: AVLabel!
    @IBOutlet weak var lblNoOfItems: AVLabel!
    
    //MARK: - Variables
    weak var delegate: CategoryTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgViewCategory.roundCorners(Constant.viewCornerRadius)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK:- Public Methods
    func configureView(categoryInfo: CategoryModel) {
        if let name = categoryInfo.name {
           self.lblCategoryName.text = name
        }
        if let imgUrl = categoryInfo.imageUrl {
            self.imgViewCategory.setImage(urlStr: imgUrl, placeHolderImage: nil)
        }
        if let itemCount = categoryInfo.productCount {
            self.lblNoOfItems.text = itemCount > 1 ? "\(itemCount) items" : "\(itemCount) item"
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapSeeAll(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapSeeAllCategory()
        }
    }
}
