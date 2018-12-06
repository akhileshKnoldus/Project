//
//  ProductQuantityCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProductQuantityCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    
    
    //MARK: - Public Methods
    func configureDataOnView(_ data: [String: Any]) {
        if let value = data[Constant.keys.kValue] as? String {
            self.lblQuantity.text = value
        }
        if let title = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = title
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapChange(_ sender: UIButton) {
        
    }
}
