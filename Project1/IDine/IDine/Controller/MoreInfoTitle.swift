//
//  MoreInfoTitle.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class MoreInfoTitle: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtView: UITextView!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Private Method
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tapBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
