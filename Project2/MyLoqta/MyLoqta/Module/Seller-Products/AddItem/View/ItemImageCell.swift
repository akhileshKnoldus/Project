//
//  ItemImageCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemImageCell: BaseCollectionViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Threads.performTaskAfterDealy(0.1) {
            self.imgView.roundCorners(4.0)
        }
    }
    
    func configureCell(data: [String: Any]) {
        
        if let image = data[Constant.keys.kImage] as? UIImage {
            self.imgView.image = image
        } else if let imageUrl = data[Constant.keys.kImageUrl] as? String {
            self.imgView.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
        }
        
        self.indicator.isHidden = true
        self.indicator.stopAnimating()
        if let imageStatus = data[Constant.keys.kImageStatus] as? ImageStatus {            
            switch imageStatus {
            case .empty: imgView.alpha = 1.0
            //self.btnRetry.isHidden = true
            self.indicator.isHidden = true
            self.btnCross.isHidden = true
                
            case .uploading: imgView.alpha = 0.2
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            self.btnCross.isHidden = true
                
            case .uploadFailed: break //self.btnRetry.isHidden = false
                
            case .uploaded: imgView.alpha = 1.0
            //self.btnRetry.isHidden = true
            self.indicator.isHidden = true
            self.btnCross.isHidden = false
            }
        }
    }

}
