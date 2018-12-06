//
//  StoreAddressTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class StoreAddressTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var lblInfo: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Public Methods
    func configureCell(data: [String: Any]) {
        
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = placeHolder
        }
        if let value = data[Constant.keys.kValue] as? String {
            self.lblInfo.text = value
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapMore(_ sender: UIButton) {
        
    }
}
