//
//  helpVM.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

protocol HelpVModeling: class {
    func requestGetNumberList(completion: @escaping (_ arrayNumbers: [Phone]) ->Void)
}

class HelpVM: BaseModeling, HelpVModeling {
    
    func requestGetNumberList(completion: @escaping (_ arrayNumbers: [Phone]) ->Void) {
        self.apiManagerInstance()?.request(apiRouter: APIRouter.init(endpoint: .getHelpDeskNumber()), completionHandler: { (response, success) in
            print(response)
            if success, let result = response as? [[String: Any]] {
                if let phoneNumbers = Phone.formattedArray(data: result) {
                    completion(phoneNumbers)
                }
            }
        })
    }
}
