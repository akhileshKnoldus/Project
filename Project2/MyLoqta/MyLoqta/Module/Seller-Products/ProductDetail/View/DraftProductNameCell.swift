//
//  DraftProductNameCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DraftProductNameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    
    @IBOutlet weak var viewDraft: UIView!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductPrice: AVLabel!
    @IBOutlet weak var lblProductCurrency: AVLabel!
    
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
        self.viewDraft.roundCorners(Constant.viewCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureDataOnView(_ product: Product?) {
        if let product = product {
            self.lblProductName.text = product.itemName
            if let price = product.price {
                let intPrice = Int(price)
                let usPrice = intPrice.withCommas()
                self.lblProductPrice.text = usPrice
            }
        }
    }
}
