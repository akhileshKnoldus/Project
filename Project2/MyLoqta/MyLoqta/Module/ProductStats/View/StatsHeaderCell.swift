//
//  StatsHeaderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol StatsHeaderCellDelegate: class {
    func didTapStatsFilter()
}

class StatsHeaderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var viewLastWeek: UIView!
    @IBOutlet weak var lblLastWeek: UILabel!
    
    //MARK: - Variables
    weak var delegate: StatsHeaderCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
        self.viewLastWeek.roundCorners(Constant.btnCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureView(itemName: String?, itemImage: String?, filterType: Int) {
        self.lblProductName.text = itemName
        if let imageUrl = itemImage {
            self.imgViewProduct.setImage(urlStr: imageUrl, placeHolderImage: nil)
        }
        if let filterText = FilterDuration(rawValue: filterType) {
            self.lblLastWeek.text = filterText.title
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapStatsFilter(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapStatsFilter()
        }
    }
}
