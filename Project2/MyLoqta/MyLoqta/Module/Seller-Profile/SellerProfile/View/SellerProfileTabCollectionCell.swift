//
//  SellerProfileHeaderCollectionCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol SelectManageStoreTypeDelegates: class {
    func didPerformActionOnTappingOnType(typeSelected: Int)
}

class SellerProfileTabCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var btnProducts: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnReviews: UIButton!
    
    //MARK: - Variables
    weak var delegate: SelectManageStoreTypeDelegates?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Public Methods
    func configureCell(typeSelected: Int) {
        switch typeSelected {
        case ManageStoresType.products.rawValue:
            self.btnProducts.isSelected = true
        case ManageStoresType.info.rawValue:
            self.btnInfo.isSelected = true
        default:
            self.btnReviews.isSelected = true
        }
        self.btnProducts.setTitle(NSLocalizedString("Products", comment: ""), for: .normal)
        self.btnInfo.setTitle(NSLocalizedString("Info", comment: ""), for: .normal)
        self.btnReviews.setTitle(NSLocalizedString("Reviews", comment: ""), for: .normal)
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapBtnProducts(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        self.btnInfo.isSelected = false
        self.btnReviews.isSelected = false
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingOnType(typeSelected: ManageStoresType.products.rawValue)
        }
    }
    
    @IBAction func tapBtnInfo(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.btnProducts.isSelected = false
        self.btnReviews.isSelected = false
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingOnType(typeSelected: ManageStoresType.info.rawValue)
        }
    }
    
    @IBAction func tapBtnReviews(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.btnInfo.isSelected = false
        self.btnProducts.isSelected = false
        if self.delegate != nil {
            self.delegate?.didPerformActionOnTappingOnType(typeSelected: ManageStoresType.reviews.rawValue)
        }
    }
}
