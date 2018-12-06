//
//  ResturantCell.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
protocol  NextPageDeligate : class
{
    func btnNextClicked(cell: UITableViewCell)
}
class ResturantCell: UITableViewCell {
    weak var nextPageDeligate : NextPageDeligate?
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblResturantName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

   
    @IBAction func tapNext(_ sender: Any) {
       if let mydeligate = self.nextPageDeligate
       {
        mydeligate.btnNextClicked(cell: self)
        }
        
    }
    
}
