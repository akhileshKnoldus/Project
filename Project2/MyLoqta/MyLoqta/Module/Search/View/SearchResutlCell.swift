//
//  SearchResutlCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SearchResutlCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblCateName: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(searchItem: SearchResult) {
        //categoryName = "Home Appliances";
        //itemName = "washing machine";
        if let name = searchItem.itemName, let storeName = searchItem.storeName {
            //self.lblItemName.text = name
            self.lblItemName.text = name.isEmpty ? storeName : name
        } else {
            self.lblItemName.text = ""
        }
        
        if let categoryName = searchItem.categoryName {
            self.lblCateName.text = categoryName
        } else {
            self.lblCateName.text = ""
        }
    
    }
    
}
