//
//  SearchStoreCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SearchStoreCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var imageViewStore: UIImageView!
    @IBOutlet weak var imgViewCheck: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        Threads.performTaskAfterDealy(0.1) {
            self.imageViewStore.roundCorners(25.0)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func configureCell(searchResult: SearchResult) {
        if let imageUrl = searchResult.profilePic {
            self.imageViewStore.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
        }
        if let storeName = searchResult.storeName {
            self.lblName.text = storeName
        } else {
            self.lblName.text = ""
        }
        
        if let isComVerified = searchResult.isCompanyVerified, isComVerified {
            self.imgViewCheck.isHidden = false
        } else {
            self.imgViewCheck.isHidden = true
        }
        self.lblType.text = "Business".localize()
    }
    
}
