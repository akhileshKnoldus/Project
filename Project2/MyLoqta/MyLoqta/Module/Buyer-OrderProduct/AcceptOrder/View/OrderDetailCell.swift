//
//  OrderDetailCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderDetailCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblShipping: UILabel!
    
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
