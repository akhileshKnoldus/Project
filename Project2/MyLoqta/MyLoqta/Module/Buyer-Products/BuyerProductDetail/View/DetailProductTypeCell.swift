//
//  DetailProductTypeCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DetailProductTypeCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var imgviewArrow: UIImageView!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var lblPlaceHolder: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product, indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.lblPlaceHolder.text = "Condition".localize()
            if let condition = product.condition, let productCondtn = productCondition(rawValue: condition) {
                self.lblValue.text = productCondtn.title
            }
        case 1:
            self.lblPlaceHolder.text = "Quantity".localize()
            if let quantity = product.quantity {
                self.lblValue.text  = "\(quantity)"
            }
        default:
            self.lblPlaceHolder.text = "Location".localize()
            self.lblValue.text = self.getAddress(prodcut: product)
        }
    }
    
    func getAddress(prodcut: Product) -> String {
        var address = ""
        if let city = prodcut.city, !city.isEmpty {
            address = "City".localize() + ":" + city
        }
        if let block = prodcut.blockNo, !block.isEmpty {
            address = address + ", " + "Block".localize() + ":" + block
        }
        if let street = prodcut.street, !street.isEmpty {
            address = address + ", " + "Street".localize() + ":" + street
        }
        if let avenue = prodcut.avenueNo, !avenue.isEmpty {
            address = address + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = prodcut.buildingNo, !building.isEmpty {
            address = address + ", " + "Building No.".localize() + ":" + building
        }
        return address
        /*
        if let block = prodcut.blockNo, !block.isEmpty {
            address = address + " " + block
        }
        
        if let street = prodcut.street, !street.isEmpty {
            address = address + " " + street
        }
        
        if let building = prodcut.buildingNo, !building.isEmpty {
            address = address + " " + building
        }
        
        if let paciNo = prodcut.paciNo, !paciNo.isEmpty {
            address = address + " " + paciNo
        }
        
        return address*/
    }
    
}
