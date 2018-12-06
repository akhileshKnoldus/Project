//
//  DraftProductVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol DraftProductVModeling: class {
    func getDataSource(productDetail: Product?) -> [[String: Any]]
    func validateData(productDetail: Product?) -> Bool
    func requestGetProductDetail(productId: Int, completion: @escaping (_ product: Product, _ isDeleted: Bool) ->Void)
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void)
}

class DraftProductVM: BaseModeling, DraftProductVModeling {

    func getDataSource(productDetail: Product?) -> [[String: Any]] {
        
        //Product Name
        let productName = [Constant.keys.kCellType: cellType.draftProductName, Constant.keys.kTitle: ""] as [String : Any]
        
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
            productCondtion[Constant.keys.kValue] = Helper.returnConditionTitle(condition: condtion)
        }
        
        //Product Location
        var productLocation = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Location".localize()] as [String : Any]
        var address = ""
        if let city = productDetail?.city, !city.isEmpty {
            address = "City".localize() + ":" + city
        }
        if let block = productDetail?.blockNo, !block.isEmpty {
            address = address + ", " + "Block".localize() + ":" + block
        }
        if let street = productDetail?.street, !street.isEmpty {
            address = address + ", " + "Street".localize() + ":" + street
        }
        if let avenue = productDetail?.avenueNo, !avenue.isEmpty {
            address = address + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = productDetail?.buildingNo, !building.isEmpty {
            address = address + ", " + "Building No.".localize() + ":" + building
        }
        productLocation[Constant.keys.kValue] = address
        
        //Product Shipping
        var productShiping = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Delivery".localize()] as [String : Any]
        if let product = productDetail, let shipping = product.shipping {
            productShiping[Constant.keys.kValue] = Helper.returnShippingTitle(shipping: shipping)
        }
        
        //Product Quantity
        var productQuantity = [Constant.keys.kCellType: cellType.productDetail, Constant.keys.kTitle: "Quantity".localize()] as [String : Any]
        if let product = productDetail, let quatity = product.quantity {
            productQuantity[Constant.keys.kValue] = String(describing: quatity)
        }
        
        let arrDetail = [productName, productCategory, productDescription, productCondtion, productLocation, productShiping, productQuantity]
        return arrDetail
    }
    
    func validateData(productDetail: Product?) -> Bool {
        
        var itemName = ""; var arrayImageUrl = [String](); var desc = ""; var catName = "";
        var itemConditon = ""; var quantity = ""; var price = ""; var shipping = ""; var location = ""
        if let product = productDetail {
            if let name = product.itemName {
                itemName = name
            }
            if let imagesUrl = product.imageUrl {
                arrayImageUrl = imagesUrl
            }
            if let description = product.description {
                desc = description
            }
            if let categoryName = product.category {
                catName = categoryName
            }
            if let condition = product.condition {
                itemConditon = "\(condition)"
            }
            if let productQuantity = product.quantity {
                quantity = "\(productQuantity)"
            }
            if let productPrice = product.price {
                price = "\(productPrice)"
            }
            if let productShipping = product.shipping {
                shipping = "\(productShipping)"
            }
            
            if let city = product.city, !city.isEmpty {
                location = city
            }
            
            if let block = product.blockNo, !block.isEmpty {
                location = location + ", " + block
            }
            
            if let street = product.street, !street.isEmpty {
                location = location + ", " + street
            }
            
            if let avenue = product.avenueNo, !avenue.isEmpty {
                location = location + ", " + avenue
            }
            if let building = product.buildingNo, !building.isEmpty {
                location = location + ", " + building
            }
            
            //Check Data is Present
            if itemName.isEmpty {
                return false
            }
            if arrayImageUrl.isEmpty {
                return false
            }
            if desc.isEmpty {
                return false
            }
            if catName.isEmpty {
                return false
            }
            if itemConditon.isEmpty {
                return false
            }
            if quantity.isEmpty {
                return false
            }
            if price.isEmpty {
                return false
            }
            if shipping.isEmpty {
                return false
            }
            if location.isEmpty {
                return false
            }
            return true
        }
        return false
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
    
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .updateStatus(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                print(result)
                completions(success)
            }
        })
    }
}
