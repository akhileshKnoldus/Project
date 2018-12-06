//
//  ReviewProductVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/26/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ReviewProductVModeling: class {
    func getDataSource(productDetail: Product?) -> [[String: Any]]
    func requestGetProductDetail(productId: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void)
}

class ReviewProductVM: BaseModeling, ReviewProductVModeling {
    
    func getDataSource(productDetail: Product?) -> [[String: Any]] {

        //Product Name
        let productName = [Constant.keys.kCellType: cellType.productName, Constant.keys.kTitle: ""] as [String : Any]
        
        //Product Category
        var productCategory = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Category".localize()] as [String : Any]
        if let product = productDetail, let category = product.category, let subCategory = product.subCategory {
            productCategory[Constant.keys.kValue] = category + " > " + subCategory
        }
        
        //Product Description
        var productDescription = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Description".localize()] as [String : Any]
        if let product = productDetail, let description = product.description {
            productDescription[Constant.keys.kValue] = description
        }
        
        //Product Condition
        var productCondtion = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Condition".localize()] as [String : Any]
        if let product = productDetail, let condtion = product.condition {
            switch condtion {
            case productCondition.new.rawValue:
                productCondtion[Constant.keys.kValue] = productCondition.new.title
            case productCondition.used.rawValue:
                productCondtion[Constant.keys.kValue] = productCondition.used.title
            default:
                productCondtion[Constant.keys.kValue] = ""
            }
        }
        
        //Product Location
        var productLocation = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Location".localize()] as [String : Any]
        var location = ""
        if let product = productDetail {
            if let city = product.city, !city.isEmpty {
                location = "City".localize() + ":" + city
            }
            if let block = product.blockNo, !block.isEmpty {
                location = location + ", " + "Block".localize() + ":" + block
            }
            if let street = product.street, !street.isEmpty {
                location = location + ", " + "Street".localize() + ":" + street
            }
            if let avenue = product.avenueNo, !avenue.isEmpty {
                location = location + ", " + "Avenue No.".localize() + ":" + avenue
            }
            if let building = product.buildingNo, !building.isEmpty {
                location = location + ", " + "Building No.".localize() + ":" + building
            }
            productLocation[Constant.keys.kValue] = location
        }
        
        //Product Shipping
        var productShiping = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Delivery".localize()] as [String : Any]
        if let product = productDetail, let shipping = product.shipping {
            switch shipping {
            case productShipping.buyerWillPay.rawValue:
                productShiping[Constant.keys.kValue] = productShipping.buyerWillPay.title
            case productShipping.iWillPay.rawValue:
                productShiping[Constant.keys.kValue] = productShipping.iWillPay.title
            case productShipping.pickup.rawValue:
                productShiping[Constant.keys.kValue] = productShipping.pickup.title
            case productShipping.iWillDeliver.rawValue:
                productShiping[Constant.keys.kValue] = productShipping.iWillDeliver.title
            default:
                productShiping[Constant.keys.kValue] = ""
            }
        }
        
        //Product Quantity
        var productQuantity = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Quantity".localize()] as [String : Any]
        if let product = productDetail, let quatity = product.quantity {
            productQuantity[Constant.keys.kValue] = String(describing: quatity)
        }
        
        let arrDetail = [productName, productCategory, productDescription, productCondtion, productLocation, productShiping, productQuantity]
        return arrDetail
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
}
