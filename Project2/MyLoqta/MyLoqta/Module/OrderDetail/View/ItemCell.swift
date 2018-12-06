//
//  ItemCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 08/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemCell: BaseTableViewCell, NibLoadableView, ReusableView { 
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblItemPrice: UILabel!
    
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(order: Product) {
        let lightGryColor = UIColor.colorWithAlpha(color: 163.0, alfa: 1.0)
        let blackColor = UIColor.colorWithAlpha(color: 38.0, alfa: 1.0)
        let lightFont = UIFont.font(name: .SFProText, weight: .Regular, size: .size_12)
        let mediumFont = UIFont.font(name: .SFProText, weight: .Medium, size: .size_12)
        
        self.lblItemName.text = order.itemName
        
        if let color = order.color {
            let colorAtt = NSMutableAttributedString(string: "Color".localize() + ": ", attributes: [NSAttributedStringKey.font: lightFont, NSAttributedStringKey.foregroundColor: lightGryColor])
            let valueAtt = NSAttributedString(string: color, attributes: [NSAttributedStringKey.font: mediumFont, NSAttributedStringKey.foregroundColor: blackColor])
            colorAtt.append(valueAtt)
            self.lblColor.attributedText = colorAtt
        } else {
            self.lblColor.text = ""
        }
        
        if let condition = order.condition {
            let condition = Helper.returnConditionTitle(condition: condition)
            let conditionAtt = NSMutableAttributedString(string: "Сondition".localize() + ": ", attributes: [NSAttributedStringKey.font: lightFont, NSAttributedStringKey.foregroundColor: lightGryColor])
            let valueAtt = NSAttributedString(string: condition, attributes: [NSAttributedStringKey.font: mediumFont, NSAttributedStringKey.foregroundColor: blackColor])
            conditionAtt.append(valueAtt)
            self.lblCondition.attributedText = conditionAtt
        } else {
            self.lblCondition.text = ""
        }
        
        if let quantity = order.quantity {
            let quantity = "\(quantity)"
            let quantityAtt = NSMutableAttributedString(string: "QTY".localize() + ": ", attributes: [NSAttributedStringKey.font: lightFont, NSAttributedStringKey.foregroundColor: lightGryColor])
            let valueAtt = NSAttributedString(string: quantity, attributes: [NSAttributedStringKey.font: mediumFont, NSAttributedStringKey.foregroundColor: blackColor])
            quantityAtt.append(valueAtt)
            self.lblQuantity.attributedText = quantityAtt
        } else {
            self.lblQuantity.text = ""
        }
        
        if let price = order.price {
            let intPrice = Int(price)
            let usPrice = intPrice.withCommas()
            self.lblItemPrice.text = usPrice
        }
        
        if let arrayImage = order.imageUrl, arrayImage.count > 0 {
            let imageUrl = arrayImage[0]
            self.imgViewItem.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
        }
    }
    
}
