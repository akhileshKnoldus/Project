//
//  SettingsCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/11/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SettingsCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var imgViewIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureData(_ data: SettingData) {
        imgViewIcon.image = data.image
        lblTitle.text = data.title
    }
}
