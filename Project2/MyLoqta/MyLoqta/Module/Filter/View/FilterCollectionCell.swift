//
//  FilterCollectionCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 14/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class FilterCollectionCell: BaseCollectionViewCell, NibLoadableView, ReusableView {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
