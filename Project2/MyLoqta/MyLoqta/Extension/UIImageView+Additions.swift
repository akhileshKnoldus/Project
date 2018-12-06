//
//  UIImageView+Additions.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 23/05/18.
//  Copyright © 2018 Ashish Chauhan. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageForRtoL() {
        if UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft, let image = self.image {
            let filppedImage = image.imageFlippedForRightToLeftLayoutDirection()
            self.image = filppedImage
        }
    }
    
    func setImage(urlStr: String, placeHolderImage: UIImage?)  {
        self.kf.setImage(with: URL(string: urlStr), placeholder: placeHolderImage, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
}
