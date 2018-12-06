//
//  SelectConditionViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/31/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SelectConditionViewC: BaseViewC {

    //MARK: - Variables
    var responseBlock: ((_ condition: String) -> Void)?
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNew(_ sender: UIButton) {
        if let responseBlock = self.responseBlock {
            responseBlock(ItemCondition.new.rawValue)
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func tapCondition(_ sender: UIButton) {
        if let responseBlock = self.responseBlock {
            responseBlock(ItemCondition.used.rawValue)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
