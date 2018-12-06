//
//  MessageAdminVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol MessageAdminVModeling: class {
    func requestGetSubjectList(completion: @escaping (_ arrayCategory: [[String: Any]]) ->Void)
    func requestSendEmail(param: [String: AnyObject], completion: @escaping (_ success: Bool) ->Void)
}

class MessageAdminVM: BaseModeling, MessageAdminVModeling {
    
    func requestGetSubjectList(completion: @escaping (_ arraySubject: [[String: Any]]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getSubjectList()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                completion(result)
            }
        })
    }
    
    func requestSendEmail(param: [String: AnyObject], completion: @escaping (_ success: Bool) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .sendEmail(param: param)), completionHandler: { (response, success) in
            print(response)
            if success {
                completion(success)
            }
        })
    }
}
