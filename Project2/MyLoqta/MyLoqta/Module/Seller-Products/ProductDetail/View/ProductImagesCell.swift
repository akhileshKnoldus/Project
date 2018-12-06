//
//  productImagesCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProductImagesCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var imgViewProducts: UIImageView!
    
    //MARK - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    func setImage(imageUrl: String) {
        self.imgViewProducts.setImage(urlStr: imageUrl, placeHolderImage:nil)
    }
}
