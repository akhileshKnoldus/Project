//
//  Resturant.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class Resturant: UITableViewCell {
    
    @IBOutlet weak var imgResutrantName: UIImageView!
    @IBOutlet weak var lblResturantOffer: UILabel!
    @IBOutlet weak var lblResturantName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
