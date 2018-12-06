//
//  OTPVerificationViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 03/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit

class OTPVerificationViewC: UIViewController , UITextFieldDelegate{
    
    //MARK:- Properties
    var txtField =  UITextField()
    let datePicker = UIDatePicker()
    
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtOcassionDate: UITextField!
    @IBOutlet weak var txtOcassionField: UITextField!
    @IBOutlet weak var txtDobField: UITextField!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var txtFieldFirstOTP: UITextField!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var enterOtpView: UIView!
    @IBOutlet weak var btnVerify: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var txtFieldSecondOTP: UITextField!
    @IBOutlet weak var txtFieldThirdOTP: UITextField!
    @IBOutlet weak var txtFieldFourthOTP: UITextField!
    @IBOutlet weak var txtFieldFifthOTP: UITextField!
    @IBOutlet weak var txtFieldSixtOTP: UITextField!
    
    //MARK:- IBAction
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    //MARK:-Private Method
    func ViewHidden()
    {
        self.btnVerify.isHidden = true
        self.enterOtpView.isHidden = true
        self.otpView.isHidden = true
        self.createdatePicker()
       }
    
    func setup(){
        txtFieldFirstOTP.delegate = self
        txtFieldSecondOTP.delegate = self
        txtFieldThirdOTP.delegate = self
        txtFieldFourthOTP.delegate = self
        txtFieldFifthOTP.delegate = self
        txtFieldSixtOTP.delegate = self
        
        txtOcassionDate.delegate = self
        txtDobField.delegate = self
        addActionToOtpTextField()
    }
    
    func addActionToOtpTextField()
    {
       
        
        txtFieldFirstOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtFieldSecondOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtFieldThirdOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtFieldFourthOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtFieldFifthOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged )
        txtFieldSixtOTP.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.txtFieldFirstOTP.becomeFirstResponder()
    }
    
    func createdatePicker()
    {
        
        datePicker.datePickerMode = .date
        txtDobField?.inputView = datePicker
        txtOcassionDate?.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let donebutton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([donebutton], animated: true)
        txtDobField?.inputAccessoryView = toolbar
        txtOcassionDate?.inputAccessoryView = toolbar
    }
    @objc func doneClicked()
    {
        // format the date
        self.view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        //txtFieldDate.text = "\(datePicker.date)"
        if txtField == txtDobField
        {
            txtDobField?.text  = dateFormatter.string(from: datePicker.date)
            return
            
        }
        
        txtOcassionDate?.text  = dateFormatter.string(from: datePicker.date)
        
    }
    
    
    //MARK:- Public Method
    
    //MARK:- IBAction
    @IBAction func tapNextButton(_ sender: Any) {
        let sb = UIStoryboard(name: "Main" , bundle: nil)
        if let verifyViewC = sb.instantiateViewController(withIdentifier: "TabBarViewC") as? TabBarViewC
        {
            self.navigationController?.pushViewController(verifyViewC, animated: false)
        }
        
    }
    @IBAction func tapVerify(_ sender: Any) {
        
        
        self.ViewHidden()
        self.popupView.isHidden = false
        
        
    }
    
    //MARK:- Table View Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        txtField = textField
    }
    
    
    @objc func textFieldDidChange(textField: UITextField){
        
        let text = textField.text
        
        if (text?.utf16.count)! == 1{
            switch textField{
            case txtFieldFirstOTP:
                txtFieldSecondOTP.becomeFirstResponder()
                break
            case txtFieldSecondOTP:
                txtFieldThirdOTP.becomeFirstResponder()
                break
            case txtFieldThirdOTP:
                txtFieldFourthOTP.becomeFirstResponder()
                break
            case txtFieldFourthOTP:
                txtFieldFifthOTP.becomeFirstResponder()
                break
            case txtFieldFifthOTP:
                txtFieldSixtOTP.becomeFirstResponder()
                break
            case txtFieldSixtOTP:
                txtFieldSixtOTP.resignFirstResponder()
                break
            default:
                break
            }
        }else{
            
        }
    }
}


