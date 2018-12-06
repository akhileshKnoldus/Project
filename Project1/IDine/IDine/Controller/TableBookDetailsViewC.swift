//
//  TableBookDetailsViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class TableBookDetailsViewC: UIViewController {
    
    //MARK:-Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var confirmBookingPopView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var tbleBookView: UIView!
    @IBOutlet weak var dateNTimeView: UIView!
    @IBOutlet weak var btnBook: UIButton!
    @IBOutlet weak var confirmBookingView: UIView!
    @IBOutlet weak var lblResturantName: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblNumberOfGuest: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblResturantAddress: UILabel!
    
    //MARK:- Life Cycle
    override func
        viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK:- Private Function
    private func hiddenView(){
        titleView.isHidden = true
        tbleBookView.isHidden = true
        dateNTimeView.isHidden = true
        confirmBookingView.isHidden = true
        btnBook.isHidden = true
        confirmBookingPopView.isHidden = false
        
    }
    
    private func moveToVerifyUser(){
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        if let verifyVC = mainSb.instantiateViewController(withIdentifier: "VerifyUserViewC") as? VerifyUserViewC {
            self.navigationController?.pushViewController(verifyVC, animated: true)
            
        }
    }
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tappedBookBtn(_ sender: Any) {
        self.hiddenView()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
