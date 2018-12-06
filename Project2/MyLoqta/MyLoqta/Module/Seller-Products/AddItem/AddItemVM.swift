//
//  AddItemVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

protocol AddItemVModeling {
    func getDataSource(productDetail: Product?, commission: CGFloat) -> [[[String: Any]]]
    func requestGetProductDetail(productId: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void)
    func requestApiToAddItem(param: [String: AnyObject], completions: @escaping ((_ sucess: Bool) -> Void), alertCallBack: @escaping () ->Void)
    func requestApiToUpdateAddItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void)
    func getAllKeyword(text: String, completion: @escaping (_ array: [[String: Any]]) -> Void)
    func requestGetSellerComission(completion: @escaping (_ commission: CGFloat) ->Void)
}

enum ItemCondition: String  {
    case new = "New"
    case used = "Used"
    
    var intValue: Int {
        switch self {
        case .new: return 1
        case .used: return 2
        }
    }
}

enum ShippingType: String {
    case buyerWillPay = "Buyer will pay"
    case iWillPay = "I will pay"
    case pickUp = "Self pickup"
    case iWillDelivery = "I will deliver"
    case homeDelivery = "Home Delivery"
    
    var intValue: Int {
        switch self {
        case .buyerWillPay: return 1
            case .iWillPay: return 2
            case .pickUp: return 3
            case .iWillDelivery: return 4
            case .homeDelivery: return 5
        }
    }
}



class AddItemVM: BaseModeling, AddItemVModeling {
   
    
    
    
    func getDataSource(productDetail: Product?, commission: CGFloat) -> [[[String: Any]]] {
        
        // First sections: 0 *****************************
        var finalArray = [[[String: Any]]] ()
        
        // Item name
        var itemName = [Constant.keys.kTitle: "Item name".localize(), Constant.keys.kValue: ""]
        if let product = productDetail, let name = product.itemName {
            itemName[Constant.keys.kValue] = name
        }
        
        // Image array
        var imageArray = [[String: Any]]()
        if let product = productDetail, let array = product.imageUrl {
            for imgUrl in array {
                imageArray.append([Constant.keys.kImageUrl: imgUrl])
            }
        }
        let images = [Constant.keys.kImageArray: imageArray]
        
        // Item description
        var desc = [Constant.keys.kTitle: "Description".localize(), Constant.keys.kValue: ""]
        if let product = productDetail, let description = product.description {
            desc[Constant.keys.kValue] = description
        }
        
        finalArray.append([itemName, images, desc])
        
        
        // Second sections: 1 *****************************
        // Second sections
        var category:[String: Any] = [Constant.keys.kTitle: "Category".localize(), Constant.keys.kValue: ""]
        if let product = productDetail, let cateName = product.category, let subCatname = product.subCategory, let catId = product.categoryId {
            category[Constant.keys.kValue] = "\(cateName) > \(subCatname)"
            category[Constant.keys.kSubCategoryId] = catId as Int
        }
        
        var condition = [Constant.keys.kTitle: "Condition".localize(), Constant.keys.kValue: ""]
         if let product = productDetail, let itemCondition = product.condition {
            if itemCondition == 1 {
                condition[Constant.keys.kValue] = ItemCondition.new.rawValue
            } else {
                condition[Constant.keys.kValue] = ItemCondition.used.rawValue
            }
        }
        
        var quantity = [Constant.keys.kTitle: "Quantity".localize(), Constant.keys.kValue: 1 as Int] as [String : Any]
        if let product = productDetail, let itemQuantity = product.quantity {
            quantity[Constant.keys.kValue] = itemQuantity
        }
        
        finalArray.append([category, condition, quantity])
        
        // Third sections: 2 *****************************
        // Third Section
        var salePrice = [Constant.keys.kTitle: "Sale price (with ".localize() + "\(commission)%" + " fee)".localize(), Constant.keys.kValue: "", Constant.keys.k10Percent: ""]
        if let product = productDetail, let price = product.price {
            salePrice[Constant.keys.kValue] = "\(price)"
        }
        finalArray.append([salePrice])
        
        // Fourth sections: 3 *****************************
        // Fourth section
        var shipping = [Constant.keys.kTitle: "Delivery".localize(), Constant.keys.kValue: ""]
        if let product = productDetail, let shiping = product.shipping {
            shipping[Constant.keys.kValue] = self.getShipping(shipingType: shiping)
        }
        
        var location = [Constant.keys.kTitle: "Location".localize(), Constant.keys.kValue: ""]
        var address = ""
        if let product = productDetail {
            
            if let city = product.city, !city.isEmpty {
                address = "City".localize() + ":" + city
            }
            if let block = product.blockNo, !block.isEmpty {
                address = address + ", " + "Block".localize() + ":" + block
            }
            if let street = product.street, !street.isEmpty {
                address = address + ", " + "Street".localize() + ":" + street
            }
            if let avenue = product.avenueNo, !avenue.isEmpty {
                address = address + ", " + "Avenue No.".localize() + ":" + avenue
            }
            if let building = product.buildingNo, !building.isEmpty {
                address = address + ", " + "Building No.".localize() + ":" + building
            }
        }
        location[Constant.keys.kValue] = address
        finalArray.append([shipping, location])
        
        // Fifth sections: 4 *****************************
        // Fifth section
        var tags = [Constant.keys.kTags: [] as [String]]
        if let product = productDetail, let arrTags = product.tags {
            tags[Constant.keys.kTags] = arrTags
        }
        finalArray.append([tags])
        return finalArray
        
    }
    
    func getShipping(shipingType: Int) -> String {
        switch shipingType {
        case 1: return "Buyer will pay".localize()
        case 2: return "I will pay".localize()
        case 3: return "Self pickup".localize()
        default: return "I will deliver".localize()
        }
    }
    
    
    //MARK: - API Methods
    func requestGetProductDetail(productId: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void) {
        let params = ["itemId": productId as AnyObject, "type": 1 as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .viewItem(param: params)), completionHandler: { (response, success) in
            if success,let data = response as? [String: AnyObject], let newResponse = data[kResult] as? [String: AnyObject] {
                if let product = Product.formattedData(data: newResponse) {
                    completion(product, false)
                }
            } else if let dataObject = response as? [String: AnyObject] , let errorCode = dataObject["Status"] as? Int, errorCode == 302 {
                completion(Product(), true)
            }
            
        })
    }
    
    
    func requestApiToAddItem(param: [String: AnyObject], completions: @escaping ((_ sucess: Bool) -> Void), alertCallBack: @escaping () ->Void) {
        apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .addItem(param: param)), completionHandler: { (response, success) in
            print(response)
            completions(success)
        })
        
        apiManagerInstance()?.successAlertCallBack = { () in
            alertCallBack()
        }
    }
    
    
    
    func requestApiToUpdateAddItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void) {
        apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .updateItem(param: param)), completionHandler: { (response, success) in
            print(response)
            completions(success)
        })
    }
    
    func getAllKeyword(text: String, completion: @escaping (_ array: [[String: Any]]) -> Void) {
        let param: [String: AnyObject] = ["tag": text as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .searchTags(param: param)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]] {
                completion(result)
            }
        })
    }
    
    func requestGetSellerComission(completion: @escaping (_ commission: CGFloat) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .sellerCommission()), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject], let commission = newResponse["sellerCommission"] as? CGFloat {
                completion(commission)
            }
        })
    }
}
