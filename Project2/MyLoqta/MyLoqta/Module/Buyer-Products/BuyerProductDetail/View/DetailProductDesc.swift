//
//  DetailProductDesc.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ReadMoreTextView

class DetailProductDesc: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var txtViewReadMore: ReadMoreTextView!
    //@IBOutlet weak var lblDesc: TTTAttributedLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(product: Product)  {
        if let itemDesc = product.description {
            self.txtViewReadMore.text = itemDesc
            
            //txtViewReadMore.shouldTrim = !expandedCells.contains(indexPath.row)
            txtViewReadMore.shouldTrim = true
            txtViewReadMore.isEditable = false
            txtViewReadMore.maximumNumberOfLines = 3
            let readMoreTextAttributes: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.foregroundColor: UIColor.appOrangeColor,
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)
            ]
            txtViewReadMore.attributedReadMoreText = NSAttributedString(string: "\nShow more", attributes: readMoreTextAttributes)
            txtViewReadMore.setNeedsUpdateTrim()
            txtViewReadMore.layoutIfNeeded()
        }
        
    }
    
}
