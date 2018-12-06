//
//  BookingCell.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class BookingCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnEditBooking: UIButton!
    
    @IBOutlet weak var btnGenerateCode: UIButton!
    
    
    @IBOutlet weak var lblBookingDate: UILabel!
    
    @IBOutlet weak var lblResturantName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func tappedEditBooking(_ sender: Any) {
    }
    
    
    
    @IBAction func tappedGenerateCode(_ sender: Any) {
    }
    
}
