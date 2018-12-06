//
//  SellerEditProfileVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol SellerEditProfileVModeling: class {
    func getStoreDataSource(seller: SellerDetail?) -> [[String: Any]]
    func getIndividualDataSource(seller: SellerDetail?) -> [[String: Any]]
    func validateDataForStore(_ arrData: [[String: Any]]) -> Bool
    func validateDataForIndividual(_ arrData: [[String: Any]]) -> Bool
    func updateStoreProfile(arrayData: [[String: Any]], address: ShippingAddress?, seller: SellerDetail?, completion: @escaping (_ success: Bool) ->Void )
    func updateIndividualSellerProfile(arrayData: [[String: Any]], address: ShippingAddress?, seller: SellerDetail?, completion: @escaping (_ success: Bool) ->Void )
}

class SellerEditProfileVM: BaseModeling, SellerEditProfileVModeling {
    
    func getStoreDataSource(seller: SellerDetail?) -> [[String: Any]] {
        
        var storeName = ""
        var aboutUs = ""
        var coverPicUrl = ""
        var profilePicUrl = ""
        var address = ""
        
        if let seller = seller {
            
            if let fName = seller.name {
                storeName = fName
            }
            
            if let aboutUs_seller = seller.info?.aboutUs {
                aboutUs = aboutUs_seller
            } // change
            
            if let cover_pic = seller.coverPic {
                coverPicUrl = cover_pic
            }
            
            if let profile_pic = seller.profilePic {
                profilePicUrl = profile_pic
            }
            
            if let city = seller.city, !city.isEmpty {
                address = "City".localize() + ":" + city
            }
            if let block = seller.blockNo, !block.isEmpty {
                address = address + ", " + "Block".localize() + ":" + block
            }
            if let street = seller.street, !street.isEmpty {
                address = address + ", " + "Street".localize() + ":" + street
            }
            if let avenue = seller.avenueNo, !avenue.isEmpty {
                address = address + ", " + "Avenue No.".localize() + ":" + avenue
            }
            if let building = seller.buildingNo, !building.isEmpty {
                address = address + ", " + "Building No.".localize() + ":" + building
            }
        }
        
        let profilePic = [Constant.keys.kProfileImage: nil, Constant.keys.kProfileImageUrl: profilePicUrl, Constant.keys.kCoverImage: nil, Constant.keys.kCoverImageUrl: coverPicUrl] as [String : Any]
        let name = [Constant.keys.kTitle: "Store name".localize(), Constant.keys.kValue: storeName] as [String : Any]
        let aboutStore = [Constant.keys.kTitle: "About store".localize(), Constant.keys.kValue: aboutUs] as [String : Any]
        let storeAddress = [Constant.keys.kTitle: "Store address".localize(), Constant.keys.kValue: address] as [String : Any]
        let addNewAddress = [Constant.keys.kTitle: "", Constant.keys.kValue: ""] as [String : Any]
        return [profilePic, name, aboutStore, storeAddress, addNewAddress]
    }
    
    func getIndividualDataSource(seller: SellerDetail?) -> [[String: Any]] {
        
        var fullName = ""
        var aboutUs = ""
        var coverPicUrl = ""
        var profilePicUrl = ""
        var address = ""
        
        if let seller = seller {
            
            if let fName = seller.name {
                fullName = fName
            }
            
            if let aboutUs_seller = seller.info?.aboutUs {
                aboutUs = aboutUs_seller
            }
            
            if let cover_pic = seller.coverPic {
                coverPicUrl = cover_pic
            }
            
            if let profile_pic = seller.profilePic {
                profilePicUrl = profile_pic
            }
            
            if let city = seller.city, !city.isEmpty {
                address = "City".localize() + ":" + city
            }
            if let block = seller.blockNo, !block.isEmpty {
                address = address + ", " + "Block".localize() + ":" + block
            }
            if let street = seller.street, !street.isEmpty {
                address = address + ", " + "Street".localize() + ":" + street
            }
            if let avenue = seller.avenueNo, !avenue.isEmpty {
                address = address + ", " + "Avenue No.".localize() + ":" + avenue
            }
            if let building = seller.buildingNo, !building.isEmpty {
                address = address + ", " + "Building No.".localize() + ":" + building
            }
        }
        
        let profilePic = [Constant.keys.kProfileImage: nil, Constant.keys.kProfileImageUrl: profilePicUrl, Constant.keys.kCoverImage: nil, Constant.keys.kCoverImageUrl: coverPicUrl] as [String : Any]
        let fewWords = [Constant.keys.kTitle: "Few words about you".localize(), Constant.keys.kValue: aboutUs] as [String : Any]
        let storeAddress = [Constant.keys.kTitle: "Address".localize(), Constant.keys.kValue: address] as [String : Any]
        let addNewAddress = [Constant.keys.kTitle: "", Constant.keys.kValue: ""] as [String : Any]
        return [profilePic, fewWords, storeAddress, addNewAddress]
    }
    
    func validateDataForStore(_ arrData: [[String: Any]]) -> Bool {
        var isValid = true
        if let storeName = arrData[1][Constant.keys.kValue] as? String, storeName.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter store name".localize())
            isValid = false
        } else if let aboutUs = arrData[2][Constant.keys.kValue] as? String, aboutUs.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter something about your store".localize())
            isValid = false
        }
        return isValid
    }
    
    func validateDataForIndividual(_ arrData: [[String: Any]]) -> Bool {
        var isValid = true
        if let fewWords = arrData[1][Constant.keys.kValue] as? String, fewWords.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter few words about yourself".localize())
            isValid = false
        }
        return isValid
    }
    
    func updateStoreProfile(arrayData: [[String: Any]], address: ShippingAddress?, seller: SellerDetail?, completion: @escaping (_ success: Bool) ->Void ) {
        
        var sellerId = ""
        var addressId = 0
        var title = ""
        var country = ""
        var city = ""
        var blockNo = ""
        var street = ""
        var avenueNo = ""
        var buildingNo = ""
        var paciNo = ""
        
        if let seller_id = Defaults[.sellerId] {
            sellerId = "\(seller_id)"
        }
        
        if let sellerInfo = seller {
            if let adresId = sellerInfo.addressId {
                addressId = adresId
            }
            
            if let adresTitle = sellerInfo.title {
                title = adresTitle
            }
            if let adrescountry = sellerInfo.country {
                country = adrescountry
            }
            if let adresCity = sellerInfo.city {
                city = adresCity
            }
            if let adresBlock = sellerInfo.blockNo {
                blockNo = adresBlock
            }
            if let adresStreet = sellerInfo.street {
                street = adresStreet
            }
            if let adresAvenue = sellerInfo.avenueNo {
                avenueNo = adresAvenue
            }
            if let adresBuilding = sellerInfo.buildingNo {
                buildingNo = adresBuilding
            }
            if let adresPACI = sellerInfo.paciNo {
                paciNo = adresPACI
            }
        }
        
        if let storeAddress = address {
            
            if let address_id = storeAddress.id {
                addressId = address_id
            }
            if let adresTitle = storeAddress.title {
                title = adresTitle
            }
            if let adrescountry = storeAddress.country {
                country = adrescountry
            }
            if let adresCity = storeAddress.city {
                city = adresCity
            }
            if let adresBlock = storeAddress.blockNo {
                blockNo = adresBlock
            }
            if let adresStreet = storeAddress.street {
                street = adresStreet
            }
            if let adresAvenue = storeAddress.avenueNo {
                avenueNo = adresAvenue
            }
            if let adresBuilding = storeAddress.buildingNo {
                buildingNo = adresBuilding
            }
            if let adresPACI = storeAddress.paciNo {
                paciNo = adresPACI
            }
        }
        
        if let coverPic = arrayData[0][Constant.keys.kCoverImageUrl], let profilePic = arrayData[0][Constant.keys.kProfileImageUrl], let storeName = arrayData[1][Constant.keys.kValue] as? String, let aboutStore = arrayData[2][Constant.keys.kValue] as? String {
            let param = ["sellerId": sellerId as AnyObject,
                         "profilePic": profilePic as AnyObject,
                         "coverPic": coverPic as AnyObject,
                         "name": storeName as AnyObject,
                         "about": aboutStore as AnyObject,
                         "addressId": addressId as AnyObject,
                         "title": title as AnyObject,
                         "country": country as AnyObject,
                         "city": city as AnyObject,
                         "blockNo": blockNo as AnyObject,
                         "street": street as AnyObject,
                         "avenueNo": avenueNo as AnyObject,
                         "buildingNo": buildingNo as AnyObject,
                         "paciNo": paciNo as AnyObject]
            self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .updateStore(param: param)), completionHandler: { (response, success) in
                print("response: \(response)")
                
                if success, let newResponse = response as? [String: AnyObject] {
                    if let updatedSeller = SellerDetail.formattedData(data: newResponse), let user = Defaults[.user] {
                        user.seller?.profilePic = updatedSeller.profilePic
                        user.seller?.name = updatedSeller.name
                        Defaults[.user] = user
                        completion(success)
                    }
                }
            })
        }
    }
    
    func updateIndividualSellerProfile(arrayData: [[String: Any]], address: ShippingAddress?, seller: SellerDetail?, completion: @escaping (_ success: Bool) ->Void ) {
        
        var sellerId = ""
        var name = ""
        var addressId = 0
        var title = ""
        var country = ""
        var city = ""
        var blockNo = ""
        var street = ""
        var avenueNo = ""
        var buildingNo = ""
        var paciNo = ""
        
        if let seller_id = Defaults[.sellerId] {
            sellerId = "\(seller_id)"
        }
        
        if let sellerInfo = seller {
            if let adresId = sellerInfo.addressId {
                addressId = adresId
            }
            
            if let sellerName = sellerInfo.name {
                name = sellerName
            }
            if let adresTitle = sellerInfo.title {
                title = adresTitle
            }
            if let adrescountry = sellerInfo.country {
                country = adrescountry
            }
            if let adresCity = sellerInfo.city {
                city = adresCity
            }
            if let adresBlock = sellerInfo.blockNo {
                blockNo = adresBlock
            }
            if let adresStreet = sellerInfo.street {
                street = adresStreet
            }
            if let adresAvenue = sellerInfo.avenueNo {
                avenueNo = adresAvenue
            }
            if let adresBuilding = sellerInfo.buildingNo {
                buildingNo = adresBuilding
            }
            if let adresPACI = sellerInfo.paciNo {
                paciNo = adresPACI
            }
        }
        
        if let storeAddress = address {
            if let address_id = storeAddress.id {
                addressId = address_id
            }
            if let adresTitle = storeAddress.title {
                title = adresTitle
            }
            if let adrescountry = storeAddress.country {
                country = adrescountry
            }
            if let adresCity = storeAddress.city {
                city = adresCity
            }
            if let adresBlock = storeAddress.blockNo {
                blockNo = adresBlock
            }
            if let adresStreet = storeAddress.street {
                street = adresStreet
            }
            if let adresAvenue = storeAddress.avenueNo {
                avenueNo = adresAvenue
            }
            if let adresBuilding = storeAddress.buildingNo {
                buildingNo = adresBuilding
            }
            if let adresPACI = storeAddress.paciNo {
                paciNo = adresPACI
            }
        }
        
        if let coverPic = arrayData[0][Constant.keys.kCoverImageUrl], let profilePic = arrayData[0][Constant.keys.kProfileImageUrl], let aboutStore = arrayData[1][Constant.keys.kValue] as? String {
            let param = ["sellerId": sellerId as AnyObject,
                         "profilePic": profilePic as AnyObject,
                         "coverPic": coverPic as AnyObject,
                         "name": name as AnyObject,
                         "about": aboutStore as AnyObject,
                         "addressId": addressId as AnyObject,
                         "title": title as AnyObject,
                         "country": country as AnyObject,
                         "city": city as AnyObject,
                         "blockNo": blockNo as AnyObject,
                         "street": street as AnyObject,
                         "avenueNo": avenueNo as AnyObject,
                         "buildingNo": buildingNo as AnyObject,
                         "paciNo": paciNo as AnyObject]
            self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .updateStore(param: param)), completionHandler: { (response, success) in
                print("response: \(response)")
                
                if success, let newResponse = response as? [String: AnyObject] {
                    if let updatedSeller = SellerDetail.formattedData(data: newResponse), let user = Defaults[.user] {
                        user.seller?.profilePic = updatedSeller.profilePic
                        user.seller?.name = updatedSeller.name
                        Defaults[.user] = user
                        completion(success)
                    }
                }
            })
        }
    }
}
