//
//  KeywordCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 30/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class KeywordCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var viewBg: AVView!
    @IBOutlet weak var btnDeleteKeyword: UIButton!
    @IBOutlet weak var lblKeyword: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
