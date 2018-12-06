//
//  PageControllCellCollectionViewCell.swift
//  IDine
//
//  Created by App on 03/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class PageControllCell: UICollectionViewCell {

    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblMainHeading: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        self.imgView.layer.cornerRadius = self.imgView.frame.width/2
        super.awakeFromNib()
        
    }
 
}
