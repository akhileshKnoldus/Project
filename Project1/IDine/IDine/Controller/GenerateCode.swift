//
//  GenerateCode.swift
//  IDine
//
//  Created by Akhilesh Gupta on 04/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class GenerateCode: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var txtOtp1: UITextField!
    @IBOutlet weak var txtOtp3: UITextField!
    @IBOutlet weak var txtOtp2: UITextField!
    @IBOutlet weak var txtOtp4: UITextField!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        
    }
    
    
    //MARK:- Private Function
    func setup(){
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        addActionToOtpTextField()
        
    }
    func addActionToOtpTextField()
    {
        txtOtp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtOtp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtOtp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtOtp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        
    }
    
    
    //MARK:- Public Function
    
    //MARK:- IBAction
    @IBAction func tappedValidateBtn(_ sender: Any) {
    }
    
    @IBAction func tappedBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- Extension
extension GenerateCode: UITextFieldDelegate
{
    //MARK:- Text Feild Delegate
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if (text?.utf16.count)! == 1{
            switch textField{
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
                break
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
                break
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
                break
            case txtOtp4:
                txtOtp4.resignFirstResponder()
                break
                
            default:
                break
            }
        }else{
            
        }
    }
    
}

