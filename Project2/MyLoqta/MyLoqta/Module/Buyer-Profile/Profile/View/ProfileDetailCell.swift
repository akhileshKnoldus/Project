//
//  ProfileDetailCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Cosmos

protocol ProfileDetailCellDelegate: class {
    func didTapFollow()
}

class ProfileDetailCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblLikesCount: AVLabel!
    @IBOutlet weak var lblFollowingCount: AVLabel!
    @IBOutlet weak var lblFollowerCount: AVLabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var lblCity: AVLabel!
    @IBOutlet weak var lblUserName: AVLabel!
    @IBOutlet weak var lblLastTitle: AVLabel!
    @IBOutlet weak var lblMiddleTitle: AVLabel!
    @IBOutlet weak var imgViewVerificationStatus: UIImageView!
    @IBOutlet weak var viewFollow: AVView!
    @IBOutlet weak var imgViewFollow: UIImageView!
    @IBOutlet weak var lblFollow: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblFollowers: AVLabel!
    @IBOutlet weak var viewRating: CosmosView!
    
    //Constarint Outlets
    @IBOutlet weak var constraintImgViewCityWidth: NSLayoutConstraint!
    
    @IBOutlet weak var constraintLblFollowersWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintFollowerCountWidth: NSLayoutConstraint!
    @IBOutlet weak var constraintLblFollowingLeading: NSLayoutConstraint!
    
    @IBOutlet weak var constraintLblUsernameLeading: NSLayoutConstraint!
    
    @IBOutlet weak var constraintLblCityHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate: ProfileDetailCellDelegate?
    var isSelfProfile: Bool = false
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setupViewForSeller() {
        self.lblMiddleTitle.text = "products".localize()
        self.lblLastTitle.text = "items sold".localize()
//        self.constraintImgViewCityWidth.constant = 15.0
        self.constraintImgViewCityWidth.constant = 0.0
        self.constraintLblCityHeight.constant = 0.0
        self.constraintLblUsernameLeading.constant = 4.0
        if !isSelfProfile {
            self.viewFollow.isHidden = false
            Threads.performTaskAfterDealy(0.05) {
                self.viewFollow.roundCorners(Constant.btnCornerRadius)
                self.viewFollow.drawGradientWithRGB(startColor: UIColor.lightOrangeGradientColor, endColor: UIColor.darkOrangeGradientColor)
            }
        }
    }
    
    private func setupFollowView(isFollow: Bool) {
        if isFollow {
            self.lblFollow.text = "Following".localize()
            self.imgViewFollow.image = #imageLiteral(resourceName: "tick")
        } else {
            self.lblFollow.text = "Follow".localize()
            self.imgViewFollow.image = #imageLiteral(resourceName: "plus_white")
        }
    }
    
    //MARK: - Public Methods
    func configureCell(user: User?)  {
        self.constraintLblFollowersWidth.constant = 0.0
        self.constraintFollowerCountWidth.constant = 0.0
        self.constraintLblFollowingLeading.constant = 0.0
        self.constraintLblUsernameLeading.constant = 0.0
        self.constraintLblCityHeight.constant = 18.0
        self.lblFollowerCount.text = ""
        self.lblFollowers.text = ""
        if let userData = user {
            if let firstName = userData.firstName, let lastName = userData.lastName {
                self.lblUserName.text = firstName + " " + lastName
                self.lblCity.text = userData.userName
            }
            if let followingCount = userData.following {
                self.lblFollowingCount.text = "\(followingCount)"
            }
            if let likeCount = userData.likes {
                self.lblLikesCount.text = "\(likeCount)"
            }
            
            if let ratingStar = userData.ratingStar {
                self.viewRating.rating = ratingStar
            }
            if let ratingCount = userData.ratingCount {
                self.lblReviewCount.text = "(\(ratingCount))"
            }
        }
        
        /*if let userData = user {
            self.lblUserName.text = userData.userName
        }
        
//        if let text = self.lblUserName.text, text.isEmpty, let savedUser = Defaults[.user] {
//            self.lblUserName.text = savedUser.userName
//        }
        
        if let text = self.lblUserName.text, text.isEmpty, let userData = user, let firstName = userData.firstName, let lastName = userData.lastName {
            self.lblUserName.text = firstName + " " + lastName
        }*/
        
    }
    
    func configureCellForSeller(seller: SellerDetail) {
        self.setupViewForSeller()
        self.lblUserName.text = seller.name
//        if let city = seller.city, !city.isEmpty {
//            self.lblCity.text = seller.city
//        } else {
//            self.lblCity.text = "Kuwait City"
//        }
        if let approvalStatus = seller.approvalStatus, approvalStatus == sellerStatus.approved.rawValue {
            self.imgViewVerificationStatus.isHidden = false
        }
        
        if let followCount = seller.followersCount {
            self.lblFollowerCount.text = "\(followCount)"
        }
        if let productCount = seller.productCount {
            self.lblFollowingCount.text = "\(productCount)"
            self.lblMiddleTitle.text = productCount > 1 ? "products".localize() : "product".localize()
        }
        if let followStatus = seller.isFollow {
            self.setupFollowView(isFollow: followStatus)
        }
        
        if let ratingStar = seller.ratingStar {
            self.viewRating.rating = ratingStar
        }
        if let ratingCount = seller.ratingCount {
            self.lblReviewCount.text = "(\(ratingCount))"
        }
    }
    @IBAction func tapFollow(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapFollow()
        }
    }
}
