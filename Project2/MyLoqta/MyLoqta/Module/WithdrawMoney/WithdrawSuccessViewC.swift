//
//  WithdrawSuccessViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol WithdrawSuccessDelegate: class {
    func didPerformActionOnDoneButton()
}

class WithdrawSuccessViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var viewPopup: UIView!
    
    //MARK: - Variables
    weak var delegate: WithdrawSuccessDelegate?
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.viewPopup.roundCorners([.topRight, .topLeft], radius: 14.0)
    }
    
    //MARK: - IBActions
    @IBAction func tapDone(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.didPerformActionOnDoneButton()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
