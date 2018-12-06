//
//  SellingProgressCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import GradientProgress

class SellingProgressCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        progressBar.roundCorners(Constant.viewCornerRadius)
        progressBar.gradientColors = [UIColor.lightOrangeGradientColor.cgColor, UIColor.darkOrangeGradientColor.cgColor]
    }
    
    //MARK: - Publci Methods
    func configureViewForSearch(insightData: InsightSelling) {
        self.lblProductName.text = insightData.itemName
        if let productPercent = insightData.searchedPercent {
            let intPrcnt = Int(productPercent)
            let floatPrcnt = Float(productPercent)
            self.lblPercentage.text = "\(intPrcnt) %"
            self.progressBar.progress = floatPrcnt/100
        }
    }
    
    func configureViewForSelling(insightData: InsightSelling) {
        self.lblProductName.text = insightData.itemName
        if let soldPercent = insightData.soldPercent {
            let intPrcnt = Int(soldPercent)
            let floatPrcnt = Float(soldPercent)
            self.lblPercentage.text = "\(intPrcnt) %"
            self.progressBar.progress = floatPrcnt/100
        }
    }
}
