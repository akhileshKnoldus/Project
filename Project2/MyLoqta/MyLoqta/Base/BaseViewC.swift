//
//  BaseViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/05/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BaseViewC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    deinit {
        
    }
    
    func refreshApi() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewC: UIGestureRecognizerDelegate {
    //GestureDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

class AccountViewC: BaseViewC {
    
    
}
