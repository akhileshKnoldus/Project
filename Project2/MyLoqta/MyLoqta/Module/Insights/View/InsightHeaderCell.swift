//
//  InsightHeaderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol InsightHeaderCellDelegate: class {
    func didTapCategories()
    func didTapFilter()
}

class InsightHeaderCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblSellingProduct: UILabel!
    @IBOutlet weak var btnCategories: UIButton!
    @IBOutlet weak var lblLastWeek: UILabel!
    @IBOutlet weak var viewLastWeek: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    
    //MARK: - Variables
    weak var delegate: InsightHeaderCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.viewLastWeek.roundCorners(Constant.btnCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureViewForStatistics(category: String, filterType: Int) {
        self.lblSellingProduct.text = "My store statistic".localize()
        self.btnCategories.isHidden = true
        self.viewSeperator.isHidden = true
        if let filterText = FilterDuration(rawValue: filterType) {
            self.lblLastWeek.text = filterText.title
        }
    }
    
    func configureViewForSearches(category: String, filterType: Int) {
        self.lblSellingProduct.text = "Top searches".localize()
        self.btnCategories.isHidden = false
        self.viewSeperator.isHidden = false
        self.btnCategories.setTitle(category, for: .normal)
        if let filterText = FilterDuration(rawValue: filterType) {
            self.lblLastWeek.text = filterText.title
        }
    }
    
    func configureViewForSelling(category: String, filterType: Int) {
        self.lblSellingProduct.text = "Top selling products".localize()
        self.btnCategories.isHidden = false
        self.viewSeperator.isHidden = false
        self.btnCategories.setTitle(category, for: .normal)
        if let filterText = FilterDuration(rawValue: filterType) {
            self.lblLastWeek.text = filterText.title
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapCategories(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapCategories()
        }
    }
    
    @IBAction func tapInsightFilter(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapFilter()
        }
    }
}
