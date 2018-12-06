//
//  AddressListVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ObjectMapper

typealias Address = (title: String, value: String)

protocol AddressListVModeling {
    
    func getAddressList(completion: @escaping (_ arrayAddress: [ShippingAddress])-> Void)
    func getAddAddressDataSource(address: ShippingAddress?) -> [Address]
    func addAddress(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ address: ShippingAddress)-> Void)
    func removeAddress(addressId: Int, completion: @escaping (_ success: Bool)-> Void)
    func updateAddress(param: [String: AnyObject], completion: @escaping (_ success: Bool)-> Void)
    func getCityList(param: [String: AnyObject], completion: @escaping (_ arrayCategory: [[String: Any]]) ->Void)
    func validateData(_ arrModel: [Address]) -> Bool
    func getCountryList() -> [[String: Any]]
    func getCityList() -> [[String: Any]]
}

class AddressListVM: BaseModeling, AddressListVModeling {
    
    
    
    func getAddAddressDataSource(address: ShippingAddress?) -> [Address] {
        var array = [Address]()
        
        // Title
        var title = Address(title: "Title".localize(), value: "")
        if let strTitle =  address?.title {
            title.value = strTitle
        }
        array.append(title)
        
        // Country
        var country = Address(title: "Country".localize(), value: "Kuwait".localize())
        if let value =  address?.country {
            country.value = value
        }
        array.append(country)
        
        // City
        var city = Address(title: "City".localize(), value: "")
        if let value =  address?.city {
            city.value = value
        }
        array.append(city)
        
        // Block No.
        var blockNo = Address(title: "Block No.".localize(), value: "")
        if let value =  address?.blockNo {
            blockNo.value = value
        }
        array.append(blockNo)
        
        // Street
        var street = Address(title: "Street".localize(), value: "")
        if let value =  address?.street {
            street.value = value
        }
        array.append(street)
        
        // Avenue No. (optional)
        var avenueNo = Address(title: "Avenue No. (optional)".localize(), value: "")
        if let value =  address?.avenueNo {
            avenueNo.value = value
        }
        array.append(avenueNo)
        
        // Building No.
        var buildingNo = Address(title: "Building No.".localize(), value: "")
        if let value =  address?.buildingNo {
            buildingNo.value = value
        }
        array.append(buildingNo)
        
        // PACI No. (optional)
        var paciNo = Address(title: "PACI No. (optional)".localize(), value: "")
        if let value =  address?.paciNo {
            paciNo.value = value
        }
        array.append(paciNo)
        
        return array
    }
    
    
    func getAddressList(completion: @escaping (_ arrayAddress: [ShippingAddress])-> Void) {
        let userId = UserSession.sharedSession.getUserId()
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addressList(userId: userId)), completionHandler: { (response, success) in
            if success, let array = response as? [[String: Any]] {
                let arrayShipping = ShippingAddress.getArray(array: array)
                completion(arrayShipping)
            }
        })
    }
    
    func addAddress(param: [String: AnyObject], completion: @escaping (_ success: Bool, _ address: ShippingAddress)-> Void)  {
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addAddress(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                if let shippingAdd = Mapper<ShippingAddress>().map(JSON: result) {
                    completion(success, shippingAdd)
                }
            }
        })
    }
    
    func removeAddress(addressId: Int, completion: @escaping (_ success: Bool)-> Void) {
        let param = ["id": addressId as AnyObject]
        apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .removeAddress(param: param)), completionHandler: { (_, success) in
            completion(success)
        })
    }
    
    func updateAddress(param: [String: AnyObject], completion: @escaping (_ success: Bool)-> Void) {
        apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .editAddress(param: param)), completionHandler: { (_, success) in
            completion(success)
        })
    }
    
    func getCityList(param: [String: AnyObject], completion: @escaping (_ arrayCategory: [[String: Any]]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getCityList(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                completion(result)
            }
        })
    }
    
    func getCountryList() -> [[String: Any]] {
        let countryOne = ["countryName": "Kuwait"]
        let arrCountry = [countryOne]
        return arrCountry
    }
    
    func getCityList() -> [[String: Any]] {
        let cityOne = ["cityName": "Kuwait City"]
        let arrCity = [cityOne]
        return arrCity
    }
    
    func validateData(_ arrModel: [Address]) -> Bool {
        var isValid = true
        let home = arrModel[0].value
        let country = arrModel[1].value
        let city = arrModel[2].value
        let blockNo = arrModel[3].value
        let street = arrModel[4].value
        let buildingNo = arrModel[6].value
        
        if home.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter title".localizedString())
            isValid = false
        } else if country.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select your country".localizedString())
            isValid = false
        } else if city.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select your city".localizedString())
            isValid = false
        } else if blockNo.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter Block No.".localizedString())
            isValid = false
        } else if street.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter Street".localizedString())
            isValid = false
        } else if buildingNo.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter Building No.".localizedString())
            isValid = false
        }
        return isValid
    }
}
