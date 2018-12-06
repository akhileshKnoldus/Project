//
//  ManageStoreInfoTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/28/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ManageStoreInfoTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblAddress: AVLabel!
    @IBOutlet weak var lblAddressVerifyStatus: AVLabel!
    @IBOutlet weak var imgViewAddressVerify: UIImageView!
    @IBOutlet weak var lblPhone: AVLabel!
    @IBOutlet weak var lblPhoneVerifyStatus: AVLabel!
    @IBOutlet weak var imgViewPhoneVerify: UIImageView!
    @IBOutlet weak var lblCompanyReg: AVLabel!
    @IBOutlet weak var lblCompanyRegVerifyStatus: AVLabel!
    @IBOutlet weak var imgViewCompanyRegVerify: UIImageView!
    @IBOutlet weak var lblAboutUsDesc: AVLabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: - Private Methods
    
    private func setAddressVerification(status: Bool) {
        if status {
            self.lblAddress.textColor = UIColor.verifiedDataColor
            self.lblAddressVerifyStatus.textColor = UIColor.verifiedDataColor
            self.lblAddressVerifyStatus.text = "Verified".localize()
            self.imgViewAddressVerify.image = #imageLiteral(resourceName: "check_blue_large")
        } else {
            self.lblAddress.textColor = UIColor.unverifiedDataColor
            self.lblAddressVerifyStatus.textColor = UIColor.unverifiedDataColor
            self.lblAddressVerifyStatus.text = "Not Verified".localize()
            self.imgViewAddressVerify.image = #imageLiteral(resourceName: "check_gray")
        }
    }
    
    private func setPhoneVerification(status: Bool) {
        if status {
            self.lblPhone.textColor = UIColor.verifiedDataColor
            self.lblPhoneVerifyStatus.textColor = UIColor.verifiedDataColor
            self.lblPhoneVerifyStatus.text = "Verified".localize()
            self.imgViewPhoneVerify.image = #imageLiteral(resourceName: "check_blue_large")
        } else {
            self.lblPhone.textColor = UIColor.unverifiedDataColor
            self.lblPhoneVerifyStatus.textColor = UIColor.unverifiedDataColor
            self.lblPhoneVerifyStatus.text = "Not Verified".localize()
            self.imgViewPhoneVerify.image = #imageLiteral(resourceName: "check_gray")
        }
    }
    
    private func setCompanyRegVerification(status: Bool) {
        if status {
            self.lblCompanyReg.textColor = UIColor.verifiedDataColor
            self.lblCompanyRegVerifyStatus.textColor = UIColor.verifiedDataColor
            self.lblCompanyRegVerifyStatus.text = "Verified".localize()
            self.imgViewCompanyRegVerify.image = #imageLiteral(resourceName: "check_blue_large")
        } else {
            self.lblCompanyReg.textColor = UIColor.unverifiedDataColor
            self.lblCompanyRegVerifyStatus.textColor = UIColor.unverifiedDataColor
            self.lblCompanyRegVerifyStatus.text = "Not Verified".localize()
            self.imgViewCompanyRegVerify.image = #imageLiteral(resourceName: "check_gray")
        }
    }
    
    //MARK: - Public Methods
    func configureCell(seller: SellerDetail) {
        if let addressVerification = seller.info?.isAddressVerified {
            self.setAddressVerification(status: addressVerification)
        }
        if let phoneVerification = seller.info?.isPhoneVerified {
            self.setPhoneVerification(status: phoneVerification)
        }
        if let companyRegVerification = seller.info?.isCompanyVerified {
            self.setCompanyRegVerification(status: companyRegVerification)
        }
        if let sellerAbout = seller.info?.aboutUs {
            self.lblAboutUsDesc.text = sellerAbout
        }
    }
    
}
