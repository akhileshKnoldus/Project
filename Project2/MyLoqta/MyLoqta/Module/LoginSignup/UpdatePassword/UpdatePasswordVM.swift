//
//  UpdatePasswordVM.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol UpdatePasswordVModeling {
    func resetPassword(param: [String: AnyObject], completion: @escaping ()->Void)
}

class UpdatePasswordVM: BaseModeling, UpdatePasswordVModeling {
    
    func resetPassword(param: [String: AnyObject], completion: @escaping ()->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .resetPassword(param: param)), completionHandler: { (response, success) in
            if success {
                completion()
            }
        })
    }
}
