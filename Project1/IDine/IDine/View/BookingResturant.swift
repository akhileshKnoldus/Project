//
//  BookingResturant.swift
//  IDine
//
//  Created by App on 05/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
protocol GenrateCodeDelegate : class {
    func getGenratedCode(cell: UITableViewCell)
    func getEditCode(cell:UITableViewCell)
}
class BookingResturant: UITableViewCell {
    weak var genrateCodeDelegate : GenrateCodeDelegate?
    @IBOutlet weak var lblBookingDetail: UILabel!
    @IBOutlet weak var lblResturantName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    
    @IBAction func tapGenerateCodeBtn(_ sender: Any) {
        
       if let myDelegate = self.genrateCodeDelegate
       {
        myDelegate.getGenratedCode(cell: self)
        }
    }
    
    @IBAction func tapEditBooking(_ sender: Any) {
        if let delegate = self.genrateCodeDelegate
        {
            delegate.getEditCode(cell: self)
        }
    }
}
