//
//  PrepareAccountDescCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class PrepareAccountDescCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblHeader: AVLabel!
    @IBOutlet weak var lblDescription: AVLabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
