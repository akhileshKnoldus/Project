//
//  PriceRangeCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftRangeSlider

protocol FilterDelegate: class {
    func priceRange(minPirce: Int, maxPrice: Int)
    func selectFilterType(cell: UITableViewCell, selectedIndex: Int)
}

class PriceRangeCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var lblPriceRange: UILabel!
    @IBOutlet weak var lblAveragePrice: UILabel!
    //@IBOutlet weak var slider: RangeSlider!
    @IBOutlet weak var viewRange: UIView!
    weak var filterDelegate: FilterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //Threads.performTaskAfterDealy(0.2) {
            //self.setup()
        //}
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let rangeSlider:RangeSlider = RangeSlider()
    
    func setup() {
        if !rangeSlider.isDescendant(of: self.viewRange) {
            var frame = viewRange.bounds
            frame.size.width = Constant.screenWidth - 32
            rangeSlider.frame = viewRange.bounds
            self.viewRange.addSubview(rangeSlider)
            rangeSlider.minimumValue = Double(10)
            rangeSlider.maximumValue = Double(100000)
            rangeSlider.lowerValue = Double(10)
            rangeSlider.upperValue = Double(100000)
            rangeSlider.hideLabels = false
            rangeSlider.trackHighlightTintColor = UIColor.appOrangeColor
            rangeSlider.trackTintColor = UIColor.colorWithAlpha(color: 243.0, alfa: 1.0)
            rangeSlider.knobHasShadow = true
            rangeSlider.addTarget(self, action: #selector(sliderValueChange(slider:)), for: .valueChanged)
        }
        //rangeSlider.knobSize = CGFont(30)
        //rangeSlider.trackThickness = CGFloat(2)
    }
    
    func updateFilter(filer: FilterValue) {
        Threads.performTaskAfterDealy(0.2) {
            self.setup()
            if filer.maxPrice == 0, filer.minPrice == 0 {
                self.rangeSlider.minimumValue = Double(10)
                self.rangeSlider.maximumValue = Double(100000)
                self.rangeSlider.lowerValue = Double(10)
                self.rangeSlider.upperValue = Double(100000)
            } else {
                self.rangeSlider.lowerValue = Double(filer.minPrice)
                self.rangeSlider.upperValue = Double(filer.maxPrice)
            }
            self.updateLable(slider: self.rangeSlider)
        }
        
        
        
    }
    
    @objc func sliderValueChange(slider: RangeSlider) {
        print("\(slider.lowerValue)")
        print("\(slider.upperValue)")
        self.updateLable(slider: slider)
        if let delegate = self.filterDelegate {
            delegate.priceRange(minPirce: Int(slider.lowerValue), maxPrice: Int(slider.upperValue))
        }
    }
    
    func updateLable(slider: RangeSlider) {
        lblPriceRange.text = "\(Int(slider.lowerValue))KD-\(Int(slider.upperValue))KD"
    }
    
}
