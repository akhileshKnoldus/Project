//
//  OrderTotalPriceCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderTotalPriceCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureView(product: Product) {
        
    }
}
