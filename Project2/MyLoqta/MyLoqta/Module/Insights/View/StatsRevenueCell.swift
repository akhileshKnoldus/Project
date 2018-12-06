//
//  StatsRevenueCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class StatsRevenueCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var lblRevenuePlaceholder: AVLabel!
    @IBOutlet weak var lblRevenue: UILabel!
    @IBOutlet weak var lblGrowthPercent: UILabel!
    @IBOutlet weak var imgViewGrowth: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setTextForGrowth(salePercent: Double, filterType: Int) {
        var strStatsGrowth = ""
        if let filterText = FilterDuration(rawValue: filterType) {
            strStatsGrowth = filterText.statsTitle
        }
        if salePercent < 0 {
            self.lblGrowthPercent.textColor = UIColor.appRedColor
            let intPercent = Int(salePercent)
            let absPercent = abs(intPercent)
            self.imgViewGrowth.image = #imageLiteral(resourceName: "saleDrop")
            self.lblGrowthPercent.text = "\(absPercent)% " + strStatsGrowth
        } else {
            self.imgViewGrowth.image = #imageLiteral(resourceName: "saleGrow")
            self.lblGrowthPercent.textColor = UIColor.greenColor
            let intPercent = Int(salePercent)
            self.lblGrowthPercent.text = "\(intPercent)% " + strStatsGrowth
        }
    }
    
    //MARK: - Public Methods
    func configureViewForRevenue(insightStat: InsightStats, filterType: Int) {
        if let salePercnt = insightStat.salePercentage {
            self.setTextForGrowth(salePercent: salePercnt, filterType: filterType)
        }
        if let revenue = insightStat.revenue {
            let intRevenue = Int(revenue)
            let usRevenue = intRevenue.withCommas()
            self.lblRevenue.text = "\(usRevenue) " + "KD".localize()
        }
    }
    
    func configureViewForViews(productStat: ProductStats?, filterType: Int) {
        if let stat = productStat {
            self.lblRevenuePlaceholder.text = "Views".localize()
            if let viewPercnt = stat.viewPercent {
                self.setTextForGrowth(salePercent: viewPercnt, filterType: filterType)
            }
            if let viewsCount = stat.viewCount {
                self.lblRevenue.text = viewsCount > 1 ? "\(viewsCount) " + "views".localize() : "\(viewsCount) " + "view".localize()
            }
        }
    }
    
    func configureViewForLikes(productStat: ProductStats?, filterType: Int) {
        if let stat = productStat {
            self.lblRevenuePlaceholder.text = "Likes".localize()
            if let likePercnt = stat.likePercent {
                self.setTextForGrowth(salePercent: likePercnt, filterType: filterType)
            }
            if let likesCount = stat.likeCount {
                self.lblRevenue.text = likesCount > 1 ? "\(likesCount) " + "likes".localize() : "\(likesCount) " + "like".localize()
            }
        }
    }
}
