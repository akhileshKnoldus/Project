//
//  GraphCollectionCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import GradientProgress

class GraphCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewDashedLeft: UIView!
    @IBOutlet weak var viewDashesRight: UIView!
    @IBOutlet weak var viewGraph: AVView!
    @IBOutlet weak var lblDate: UILabel!
    
    //Constraint Outlet
    @IBOutlet weak var constraintViewGraphHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupView() {
        viewGraph.roundCorners([.topRight, .topLeft], radius: 4.0)
        viewGraph.drawGradient()
    }
    
    //MARK: - Public Methods
    func configureView(graphData: GraphView, filterType: Int) {
        if let amount = graphData.stats {
            let grphHeight = CGFloat(amount)
            self.constraintViewGraphHeight.constant = grphHeight
        }
        
        if let duration = FilterDuration(rawValue: filterType) {
            switch duration {
            case .lastWeek, .lastMonth:
                if let date = graphData.date {
                    let graphDate = date.UTCToLocal(toFormat: "MMM dd")
                    self.lblDate.text = graphDate
                }
            case .lastYear:
                if let date = graphData.date {
                    let graphDate = date.prefix(3)
                    self.lblDate.text = "\(graphDate)"
                }
            }
        }
    }
}
