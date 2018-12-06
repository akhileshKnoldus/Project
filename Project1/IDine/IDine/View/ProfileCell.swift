//
//  ProfileCell.swift
//  IDine
//
//  Created by App on 05/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
protocol NextButtonClickedDeligate : class {
    func nextButtonClicked(cell: UITableViewCell)
}
class ProfileCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNumberOfBooking: UILabel!
    
    @IBOutlet weak var lblHeading: UILabel!
    weak var nextButtonClickedDeligate : NextButtonClickedDeligate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    @IBAction func tapNextBtn(_ sender: Any) {
        
    }
}
