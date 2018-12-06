//
//  ProductNameCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProductNameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var viewPublishedDate: UIView!
    @IBOutlet weak var lblPublished: AVLabel!
    @IBOutlet weak var lblPublishedDate: UILabel!
    @IBOutlet weak var viewActive: UIView!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductPrice: AVLabel!
    
    //MARK: - Variables
    var isReviewProduct: Bool = false {
        didSet {
            if isReviewProduct {
                self.lblPublished.text = "Created:".localize()
                self.viewActive.isHidden = true
            }
        }
    }
    
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
        self.viewActive.roundCorners(Constant.viewCornerRadius)
    }
    
    //MARK: - Public Methods
    func configureDataOnView(_ product: Product?) {
        if let product = product {
            if let date = product.createdDate {
                let publishedDate = date.UTCToLocal(toFormat: "YYYY-MM-dd HH:mm")
                self.lblPublishedDate.text = publishedDate
            }
            self.lblProductName.text = product.itemName
            if let price = product.price {
                let intPrice = Int(price)
                let usPrice = intPrice.withCommas()
                self.lblProductPrice.text = usPrice
            }
        }
    }
}
