//
//  BookingCell.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
protocol  BookNowDeligate : class
{
    func btnBookNowClicked(cell: UICollectionViewCell)
}
class BookingCell: UICollectionViewCell {

    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
     weak var bookNowDeligate : BookNowDeligate?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func tapBookNow(_ sender: Any) {
        if let myDeligate = self.bookNowDeligate
        {
            myDeligate.btnBookNowClicked(cell: self)
        }
    }
}
