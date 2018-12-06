//
//  VerifyPhoneViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 06/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class VerifyPhoneViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var lblVerifyPhone: AVLabel!
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var constraintBottomNextButton: NSLayoutConstraint!
    var isUpdatePhone = false
    
    //MARK: - Variables
    var viewModel: VerifyPhoneVModeling?
    let bottomHt = CGFloat(0)
    
    //let phone = self.txtFieldPhoneNumber.text
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        self.deregisterFromKeyboardNotifications()
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.registerForKeyboardNotifications()
        self.txtFieldPhoneNumber.placeholder = "Your phone number".localize()
        self.txtFieldPhoneNumber.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
        self.setupUpdateText()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = VerifyPhoneVM()
        }
    }
    
    private func setupUpdateText() {
        if isUpdatePhone {
            self.lblVerifyPhone.text = "Update phone".localize()
        }
    }

    // MARK: - Notifications
    private func registerForKeyboardNotifications() {
        //Adding noti. on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: - SelectorMethods
    @objc func keyboardDidShow(notification: NSNotification) {
        Threads.performTaskInMainQueue {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            if let height = keyboardSize?.height {
                self.constraintBottomNextButton.constant = height
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraintBottomNextButton.constant = bottomHt
        self.view.updateConstraintsIfNeeded()
    }
    
    @objc func tapDone() {
        self.txtFieldPhoneNumber.resignFirstResponder()
    }
    // MARK: - IBAction functions
    @IBAction func tapCountryCode(_ sender: UIButton) {
        if let array = self.viewModel?.getCountryList() {
            print(array)
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Choose country code".localize(), arrayList: array, keyValue: "country_name") { (response) in
                print(response)
                if let result = response as? [String: AnyObject], let code = result["country_dialing_code"] as? String {
                    self.btnCountryCode.setTitle(code.trim(), for: .normal)
                } 
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    @IBAction func tapNext(_ sender: Any) {
        if let countryCode = self.btnCountryCode.title(for: .normal), let phone = self.txtFieldPhoneNumber.text, let viewModel = self.viewModel, viewModel.validatePhoneNumber(phone) {
            self.viewModel?.requestToSendOtp(phone: phone, countryCode: countryCode, completion: { (success) in
                if let optVC = DIConfigurator.sharedInst().getOTPViewC() {
                    optVC.phoneNumber = phone
                    optVC.countryCode = countryCode
                    optVC.isUpdatePhone = self.isUpdatePhone
                    self.navigationController?.pushViewController(optVC, animated: true)
                }
            })
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        UserSession.sharedSession.clearDataOfUserSession()
        AppDelegate.delegate.showEmptyProfile()
    }
}

extension VerifyPhoneViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            var finalText = text.replacingCharacters(in: textRange, with: string)
            if finalText.utf16.count == 1 {
                if (finalText == "9" || finalText == "6" || finalText == "5") {
                    return true
                } else {
                    return false
                }
            }
            if finalText.count == Constant.validation.kPhoneLength+1 {
                return false
            }
        }
        return true
    }
}

