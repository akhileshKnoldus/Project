//
//  LoginViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LoginViewC: BaseViewC {
    
    @IBOutlet weak var bottomCnstBtnSignin: NSLayoutConstraint!
    @IBOutlet weak var lblSignin: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var btnEye: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignin: GradientButtonView!
    @IBOutlet weak var viewEmailLine: UIView!
    @IBOutlet weak var viewPassLine: UIView!
    
    //MARK: - Variables
    var viewModel: LoginVModeling?
    let bottomHt = CGFloat(0)
    var strEmail = ""
    var strPassword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.deregisterFromKeyboardNotifications()
    }
    
    // MARK: - Private functions
    
    private func setup() {
        self.recheckVM()
        self.registerForKeyboardNotifications()
        self.setLocalization()
        self.txtFieldEmail.autocorrectionType = .no
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = LoginVM()
        }
    }
    
    private func setLocalization() {
        let signInText = NSLocalizedString("Sign in", comment: "")
        self.lblSignin.text = signInText
        self.btnSignin.setTitle(signInText, for: .normal)
        self.lblEmail.text = NSLocalizedString("Email", comment: "")
        self.lblPassword.text = NSLocalizedString("Password", comment: "")
        self.btnForgotPassword.setTitle("Forgot password?", for: .normal)
    }
    
    fileprivate func removeLineColor() {
        self.viewEmailLine.backgroundColor = UIColor.lineBgColor
        self.viewPassLine.backgroundColor = UIColor.lineBgColor
    }
    
    fileprivate func updatedLineColor(textField: UITextField) {
        self.removeLineColor()
        if textField == self.txtFieldEmail {
            self.viewEmailLine.backgroundColor = UIColor.appOrangeColor
        } else {
            self.viewPassLine.backgroundColor = UIColor.appOrangeColor
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        Threads.performTaskInMainQueue {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            if let height = keyboardSize?.height {
                self.bottomCnstBtnSignin.constant = height
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomCnstBtnSignin.constant = bottomHt
        self.view.updateConstraintsIfNeeded()
    }
    
    private func checkPhoneVerification() {
        if let user = Defaults[.user], let phoneVerified = user.isPhoneVerified {
            if phoneVerified == 1 {
                
                if UserSession.sharedSession.guestCheckout {
                    self.handleGuestCheckout()
                    return
                } else {
                   AppDelegate.delegate.showHome()
                }
            } else {
                if let termCondVC = DIConfigurator.sharedInst().getTermsAndCondVC() {
                    self.navigationController?.pushViewController(termCondVC, animated: true)
                }
            }
        }
    }
    
    
    func handleGuestCheckout() {
        
        if !UserSession.sharedSession.param.isEmpty {
            
            self.viewModel?.requestToAddCartItem(param: UserSession.sharedSession.param, completion: { (cartItemId) in
                    
                /*if !isFromBuyNow {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Item is added to cart successfully".localize())
                    return
                } else {*/
                
                Threads.performTaskAfterDealy(1.0, {
                    if let addressList = DIConfigurator.sharedInst().getAddressList() {
                        addressList.isForCheckout = true
                        addressList.isForBuyNow = true
                        self.navigationController?.pushViewController(addressList, animated: true)
                    }
                })
                
               // }
            })
        }
    }
    
    // MARK: - IBAction functions
    
    @IBAction func tapCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapEye(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.txtFieldPassword.isSecureTextEntry = sender.isSelected
    }
    
    @IBAction func tapForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapSignin(_ sender: Any) {
        self.view.endEditing(true)
        if let viewModel = self.viewModel, viewModel.validateData(email: strEmail, password: strPassword) {
            self.viewModel?.callLoginApi(email: strEmail, password: strPassword, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.checkPhoneVerification()
                }
            })
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
}

extension LoginViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.updatedLineColor(textField: textField)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let str = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            switch textField {
            case txtFieldEmail:
                self.strEmail = str
            case txtFieldPassword:
                self.strPassword = str
            default:
                break
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldEmail {
            self.txtFieldPassword.becomeFirstResponder()
            return false
        }
        textField.resignFirstResponder()
        self.tapSignin(self.btnSignin)
        self.removeLineColor()
        return true
    }
}
