//
//  StatsListingCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class StatsListingCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblPlaceholder: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureViewForStoreStats(indexPath: IndexPath, insightStat: InsightStats) {
        switch indexPath.row {
        case 3:
            self.lblPlaceholder.text = "Active listing".localize()
            if let listingCount = insightStat.productCount {
                self.lblValue.text = "\(listingCount)"
            }
        case 4:
            self.lblPlaceholder.text = "Orders".localize()
            if let orderCount = insightStat.order {
                self.lblValue.text = "\(orderCount)"
            }
        case 5:
            self.lblPlaceholder.text = "Sold".localize()
            if let soldCount = insightStat.sold {
                self.lblValue.text = "\(soldCount)"
            }
        default:
            return
        }
    }
    
    func configureViewForProductStats(indexPath: IndexPath, productStat: ProductStats, filterType: Int) {
        if let duration = FilterDuration(rawValue: filterType) {
            switch duration {
            case .lastWeek, .lastMonth:
                self.lblPlaceholder.text = "Average per day".localize()
            case .lastYear:
                self.lblPlaceholder.text = "Average per month".localize()
            }
        }
        
        switch indexPath.row {
        case 3:
            if let viewAvg = productStat.averageView {
                let strViewAvg = String(format: "%.1f", viewAvg)
                self.lblValue.text = "\(strViewAvg) " + "views".localize()
            }
        case 6:
            if let likeAvg = productStat.averageLike {
                let strLikeAvg = String(format: "%.1f", likeAvg)
                self.lblValue.text = "\(strLikeAvg) " + "likes".localize()
            }
        default:
            return
        }
    }
}
