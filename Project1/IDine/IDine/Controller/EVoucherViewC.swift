//
//  EVoucherViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 05/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class EVoucherViewC: UIViewController {
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var lblBdayBoyName: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValidDate: UILabel!
    @IBOutlet weak var lblVoucherNo: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
          
    }
    
    //MARK:- Private Method
    
    //MARK:- IBAction
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func tappedRedeemBtn(_ sender: Any) {
    }
    
    
    
}
