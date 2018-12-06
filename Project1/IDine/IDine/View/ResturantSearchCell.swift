//
//  ResturantSearchCell.swift
//  IDine
//
//  Created by App on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
protocol ResturantSearchDeligate : class {
    func btnItalianClicked(cell: UITableViewCell)
    func btnChineseClicked(cell: UITableViewCell)
    
}
class ResturantSearchCell: UITableViewCell {
    
    var resturantSearchDeligate : ResturantSearchDeligate?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblResturantAddress: UILabel!
    @IBOutlet weak var lblResturantName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    @IBAction func tapItalian(_ sender: Any) {
       if let mydeligate = self.resturantSearchDeligate
       {
        mydeligate.btnItalianClicked(cell: self)
        }
    }
    
    @IBAction func tapChinese(_ sender: Any) {
        if let mydeligate = self.resturantSearchDeligate
        {
            mydeligate.btnChineseClicked(cell: self)
        }
    }
}
