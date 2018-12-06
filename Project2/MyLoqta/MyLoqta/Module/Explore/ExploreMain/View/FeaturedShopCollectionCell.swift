//
//  FeaturedShopCollectionCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/22/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class FeaturedShopCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewShop: UIImageView!
    @IBOutlet weak var viewShadow: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUp()
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.addShadow()
        self.imgViewShop.roundCorners(self.imgViewShop.layer.frame.size.width/2)
        //self.configureViewForShadow()
    }
    
    private func addShadow() {
        self.viewShadow.layer.shadowColor = UIColor.gray.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewShadow.layer.shadowOpacity = 0.2
        self.viewShadow.layer.shadowRadius = 5.0
        self.viewShadow.layer.cornerRadius = 8
    }
    
    private func configureViewForShadow() {
        self.viewShadow.layer.shadowColor = UIColor.shadowColor.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewShadow.layer.shadowOpacity = 0.2
        self.viewShadow.layer.shadowRadius = 5.0
        self.viewShadow.layer.cornerRadius = 8.0
    }
}
