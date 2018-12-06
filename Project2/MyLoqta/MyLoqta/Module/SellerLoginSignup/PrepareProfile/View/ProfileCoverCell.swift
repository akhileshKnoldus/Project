//
//  ProfileCoverCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProfileCoverCellDelegate: class {
    func profileImageDidTap()
    func coverImageDidTap()
}

class ProfileCoverCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imgViewCover: UIImageView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var profileEditView: UIView!
    @IBOutlet weak var btnEditProfileImage: UIButton!
    @IBOutlet weak var btnEditCoverImage: UIButton!
    @IBOutlet weak var coverEditView: UIView!
    @IBOutlet weak var indicatorCover: UIActivityIndicatorView!
    @IBOutlet weak var indicatorProfile: UIActivityIndicatorView!
    //MARK: - Variables
    
    var delegate: ProfileCoverCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - PrivateMethods
    
    private func setup() {
        self.profileView.roundCorners(self.profileView.frame.size.width / 2)
        self.imgViewProfile.roundCorners(self.imgViewProfile.frame.size.width / 2)
        self.imgViewCover.roundCorners(8.0)
        self.coverEditView.roundCorners(8.0)
        self.indicatorCover.isHidden = true
        self.indicatorProfile.isHidden = true
    }
    
    func configureView(profileImage:UIImage?, coverImage: UIImage?, cvImgStatus: ImageStatus? = nil, pfImgStatus: ImageStatus? = nil) {
        if let profilePic = profileImage {
            self.imgViewProfile.contentMode = .scaleAspectFill
            self.imgViewProfile.image = profilePic
        } else {
            self.imgViewProfile.contentMode = .center
            self.imgViewProfile.image = #imageLiteral(resourceName: "user_placeholder")
        }
        if let coverPic = coverImage {
            self.imgViewCover.image = coverPic
        }
        
        self.updateIndicator(cvImgStatus: cvImgStatus, pfImgStatus: pfImgStatus)
    }
    
    func configureEditProfileView(data: [String: Any?], cvImgStatus: ImageStatus? = nil, pfImgStatus: ImageStatus? = nil) {
        
        //let profileImage = imageData[Constant.keys.kProfileImage] as? UIImage
        //let coverImage = imageData[Constant.keys.kCoverImage] as? UIImage
        //cell.configuriew(profileImage: profileImage, coverImage: coverImage)
        
        if let profileImage = data[Constant.keys.kProfileImage] as? UIImage {
            self.imgViewProfile.image = profileImage
            self.imgViewProfile.contentMode = .scaleAspectFill
        } else if let imgUrl = data[Constant.keys.kProfileImageUrl] as? String, !imgUrl.isEmpty {
            self.imgViewProfile.contentMode = .scaleAspectFill
            self.imgViewProfile.setImage(urlStr: imgUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        } else {
            self.imgViewProfile.contentMode = .scaleToFill
            self.imgViewProfile.image = #imageLiteral(resourceName: "user_placeholder_circle")
        }
        
        
        if let coverImage = data[Constant.keys.kCoverImage] as? UIImage {
            self.imgViewCover.image = coverImage
        } else if let imgUrl = data[Constant.keys.kCoverImageUrl] as? String {
            self.imgViewCover.setImage(urlStr: imgUrl, placeHolderImage: nil)
        }
        
        self.updateIndicator(cvImgStatus: cvImgStatus, pfImgStatus: pfImgStatus)
        
    }
    
    
    func updateIndicator(cvImgStatus: ImageStatus? = nil, pfImgStatus: ImageStatus? = nil) {
        
        self.indicatorCover.isHidden = true
        self.indicatorCover.stopAnimating()
        if let coverImgStatus = cvImgStatus {
            switch coverImgStatus {
            case .empty: break
            case .uploading:
                self.indicatorCover.isHidden = false
                self.indicatorCover.startAnimating()
            case .uploaded: break
            case .uploadFailed: break
            }
        }
        
        self.indicatorProfile.isHidden = true
        self.indicatorProfile.stopAnimating()
        if let profileImgStatus = pfImgStatus {
            switch profileImgStatus {
            case .empty: break
            case .uploading:
                self.indicatorProfile.isHidden = false
                self.indicatorProfile.startAnimating()
            case .uploaded: break
            case .uploadFailed: break
            }
        }
    }
    
    @IBAction func profileImageEditTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.profileImageDidTap()
        }
    }
    
    @IBAction func coverImageEditTapped(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.coverImageDidTap()
        }
    }
}
