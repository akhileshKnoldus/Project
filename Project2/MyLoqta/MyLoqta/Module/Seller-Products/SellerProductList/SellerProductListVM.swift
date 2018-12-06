//
//  ProductListVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

typealias SellerProductType = (cellType: Int , height: CGFloat, product: Product, headerTitle: String, showRecent: Bool)

protocol SellerProductListVModeling: class {
    func getDatasourceForSellerProductList(productList: ProductList) -> [[SellerProductType]]
    func getDatasourceForSellerOrdersList(productList: ProductList) -> [[SellerProductType]]
    func getDatasourceForDraftedProductList(productList: ProductList) -> [[SellerProductType]]
    func requestGetProductsList(listType: Int, isShowLoader: Bool, completion: @escaping (_ productList: ProductList) ->Void)
    func requestGetOrdersList(isShowLoader: Bool, completion: @escaping (_ productList: ProductList) ->Void)
    func requestToAcceptOrder(orderDetailId: Int, type: Int, completion: @escaping (_ success: Bool) ->Void)
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void)
}

class SellerProductListVM: BaseModeling, SellerProductListVModeling {
    
    //DataSourceForProductList
    func getDatasourceForSellerProductList(productList: ProductList) -> [[SellerProductType]] {
        
        //ProductDataSource
        var arrProductDataSource = [[SellerProductType]]()
        
        //ActiveProductsDataSource
        if let arrActiveProducts = productList.activeProducts, arrActiveProducts.count > 0 {
            var activeProductDataSource = [SellerProductType]()
            let headerTitle = "On sale".localize() + " (\(arrActiveProducts.count))"
            for product in arrActiveProducts {
                let activeProduct = SellerProductType(SellerProductCell.activeProductCell.rawValue, SellerProductCell.activeProductCell.height, product, headerTitle, true)
                activeProductDataSource.append(activeProduct)
            }
            arrProductDataSource.append(activeProductDataSource)
        }
        
        //ReviewProductDataSource
        if let arrReviewProducts = productList.reviewProducts, arrReviewProducts.count > 0 {
            var reviewProductDataSource = [SellerProductType]()
            let headerTitle = "On review".localize() + " (\(arrReviewProducts.count))"
            for product in arrReviewProducts {
                let reviewProduct = SellerProductType(SellerProductCell.reviewProductCell.rawValue, SellerProductCell.reviewProductCell.height, product, headerTitle, false)
                reviewProductDataSource.append(reviewProduct)
            }
            arrProductDataSource.append(reviewProductDataSource)
        }
        
        //RejectedProductDataSource
        if let arrRejectedProducts = productList.rejectedProducts, arrRejectedProducts.count > 0 {
            var rejectedProductDataSource = [SellerProductType]()
            let headerTitle = "Rejected".localize() + " (\(arrRejectedProducts.count))"
            for product in arrRejectedProducts {
                let rejectedProduct = SellerProductType(SellerProductCell.rejectedProductCell.rawValue, SellerProductCell.rejectedProductCell.height, product, headerTitle, false)
                rejectedProductDataSource.append(rejectedProduct)
            }
            arrProductDataSource.append(rejectedProductDataSource)
        }
        return arrProductDataSource
    }
    
    //DataSourceForOrdersList
    func getDatasourceForSellerOrdersList(productList: ProductList) -> [[SellerProductType]] {
        
        //ProductDataSource
        var arrOrdersDataSource = [[SellerProductType]]()
        
        //ActiveProductsDataSource
        if let arrActiveOrders = productList.activeOrders, arrActiveOrders.count > 0 {
            var activeOrdersDataSource = [SellerProductType]()
            let ordersCount = arrActiveOrders.count
            let headerTitle = ordersCount > 1 ? "Items".localize() + " (\(ordersCount))" : "Item".localize() + " (\(ordersCount))"
            for product in arrActiveOrders {
                if let status = product.orderStatus, let orderStatus = OrderStatus(rawValue: status), let shipping = product.shipping, let shippingType = productShipping(rawValue: shipping) {
                    switch orderStatus {
                        //NewOrder
                    case .newOrder:
                        let newOrder = SellerProductType(SellerProductCell.newOrderCell.rawValue, SellerProductCell.newOrderCell.height, product, headerTitle, true)
                        activeOrdersDataSource.append(newOrder)
                        
                       //WaitingForPickup
                    case .waitingForPickup:
                        if shippingType == .iWillDeliver || shippingType == .pickup {
                            let buyerPickupOrder = SellerProductType(SellerProductCell.buyerPickupOrderCell.rawValue, SellerProductCell.buyerPickupOrderCell.height, product, headerTitle, true)
                            activeOrdersDataSource.append(buyerPickupOrder)
                        } else {
                            let readyForPickupOrder = SellerProductType(SellerProductCell.readyForPickupOrderCell.rawValue, SellerProductCell.readyForPickupOrderCell.height, product, headerTitle, true)
                            activeOrdersDataSource.append(readyForPickupOrder)
                        }
                        
                        //OnTheWay
                    case .onTheWay:
                        if shippingType == .iWillDeliver || shippingType == .pickup {
                            let buyerPickupOrder = SellerProductType(SellerProductCell.buyerPickupOrderCell.rawValue, SellerProductCell.buyerPickupOrderCell.height, product, headerTitle, true)
                            activeOrdersDataSource.append(buyerPickupOrder)
                        } else {
                            let driverDropOrder = SellerProductType(SellerProductCell.driverDropOrderCell.rawValue, SellerProductCell.driverDropOrderCell.height, product, headerTitle, true)
                            activeOrdersDataSource.append(driverDropOrder)
                        }
                        
                        //Delivered
                    case .delivered:
                        let readyForPickupOrder = SellerProductType(SellerProductCell.readyForPickupOrderCell.rawValue, SellerProductCell.readyForPickupOrderCell.height, product, headerTitle, true)
                        activeOrdersDataSource.append(readyForPickupOrder)
                        
                        //RestCases
                    default:
                        let driverDropOrder = SellerProductType(SellerProductCell.driverDropOrderCell.rawValue, SellerProductCell.driverDropOrderCell.height, product, headerTitle, true)
                        activeOrdersDataSource.append(driverDropOrder)
                    }
                }
            }
            arrOrdersDataSource.append(activeOrdersDataSource)
        }
        
        //RejectedOrdersDataSource
        if let arrRejectedOrders = productList.rejectedOrders, arrRejectedOrders.count > 0 {
            var rejectedOrderDataSource = [SellerProductType]()
            let headerTitle = "Rejected".localize() + " (\(arrRejectedOrders.count))"
            for product in arrRejectedOrders {
                let rejectedOrder = SellerProductType(SellerProductCell.rejectedOrderCell.rawValue, SellerProductCell.rejectedOrderCell.height, product, headerTitle, false)
                rejectedOrderDataSource.append(rejectedOrder)
            }
            arrOrdersDataSource.append(rejectedOrderDataSource)
        }
        return arrOrdersDataSource
    }
    
    //DataSourceForDraftProductList
    func getDatasourceForDraftedProductList(productList: ProductList) -> [[SellerProductType]] {
        
        //DraftedProductDataSource
        var arrDraftedProductDataSource = [[SellerProductType]]()
        
        //ActiveProductsDataSource
        if let arrDraftedProducts = productList.draftedProducts, arrDraftedProducts.count > 0 {
            var draftedProductDataSource = [SellerProductType]()
            let productsCount = arrDraftedProducts.count
            let headerTitle = productsCount > 1 ? "Items".localize() + " (\(productsCount))" : "Item".localize() + " (\(productsCount))"
            for product in arrDraftedProducts {
                let draftedProduct = SellerProductType(SellerProductCell.draftProductCell.rawValue, SellerProductCell.draftProductCell.height, product, headerTitle, true)
                draftedProductDataSource.append(draftedProduct)
            }
            arrDraftedProductDataSource.append(draftedProductDataSource)
        }
        return arrDraftedProductDataSource
    }
    
    //MARK: - API Methods
    func requestGetProductsList(listType: Int, isShowLoader: Bool, completion: @escaping (_ productList: ProductList) ->Void) {
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "type": listType as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .viewSellerItems(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let productList = ProductList.formattedData(data: newResponse) {
                    completion(productList)
                }
            }
        })
    }
    
    func requestGetOrdersList(isShowLoader: Bool, completion: @escaping (_ productList: ProductList) ->Void) {
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject]
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .SellerOrders(param: params, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                if let productList = ProductList.formattedData(data: newResponse) {
                    completion(productList)
                }
            }
        })
    }
    
    func requestToAcceptOrder(orderDetailId: Int, type: Int, completion: @escaping (_ success: Bool) ->Void) {
        //type = 2 for accepting order
        //type = 4 for item deliverd
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "orderDetailId": orderDetailId as AnyObject, "type": type as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .orderStatusChange(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                completion(success)
            }
        })
    }
    
    func requestApiToPublishItem(param: [String: AnyObject], completions: @escaping (_ sucess: Bool) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .publishItemOrder(param: param)), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [String: Any] {
                print(result)
                completions(success)
            }
        })
    }
}
