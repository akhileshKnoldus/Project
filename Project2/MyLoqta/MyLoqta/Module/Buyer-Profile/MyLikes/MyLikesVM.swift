//
//  MyLikesVM.swift
//  MyLoqta
//
//  Created by Kirti on 8/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol MyLikesVModeling {
    func getMyLikesList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping ([Product]) -> Void)
}

class MyLikesVM: BaseModeling, MyLikesVModeling {
    func getMyLikesList(param: [String: AnyObject], isShowLoader: Bool, completion: @escaping ([Product]) -> Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .myLikes(param: param, isShowLoader: isShowLoader)), completionHandler: { (response, success) in
            if success, let result = response as? [[String: Any]]   {
                if let array = Product.formattedArray(data: result) {
                    completion(array)
                }
            }
        })
    }
}
