//
//  RejectReasonVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyUserDefaults

protocol RejectReasonVModeling: class {
    func requestGetRejectReasons(completion: @escaping (_ arrReasons: [[String: Any]]) ->Void)
    func requestToRejectOrder(orderDetailId: Int, rejectId: Int, rejectReason: String, completion: @escaping (_ success: Bool) ->Void)
}

class RejectReasonVM: BaseModeling, RejectReasonVModeling {
    
    func requestGetRejectReasons(completion: @escaping (_ arrReasons: [[String: Any]]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .rejectReasons()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                if result.count > 0 {
                    completion(result)
                }
            }
        })
    }
    
    func requestToRejectOrder(orderDetailId: Int, rejectId: Int, rejectReason: String, completion: @escaping (_ success: Bool) ->Void) {
        
        let sellerId = Defaults[.sellerId]
        let params = ["sellerId": sellerId as AnyObject, "orderDetailId": orderDetailId as AnyObject, "rejectType": rejectId as AnyObject, "rejectReason": rejectReason as AnyObject]
        
        self.apiManagerInstance()?.request(apiRouter: APIRouter(endpoint: .orderStatusReject(param: params)), completionHandler: { (response, success) in
            if success, let newResponse = response as? [String: AnyObject] {
                completion(success)
            }
        })
    }
}
