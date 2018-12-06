//
//  OTPViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 07/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class OTPViewC: BaseViewC {

    @IBOutlet weak var cnstTopVerifyPhone: NSLayoutConstraint!
    @IBOutlet var viewsOTP: [UIView]!
    @IBOutlet weak var txtFieldFirst: AVTextField!
    @IBOutlet weak var txtFieldFourth: AVTextField!
    @IBOutlet weak var txtFieldThird: AVTextField!
    @IBOutlet weak var txtFieldSecond: AVTextField!
    @IBOutlet weak var lblPhoneNumber: AVLabel!
    @IBOutlet weak var constraintBottomVerifyButton: NSLayoutConstraint!
    
    var viewModel: VerifyPhoneVModeling?
    var isUpdatePhone = false

    var arrayTextField = [UITextField]()
    let bottomHt = CGFloat(0)
    var phoneNumber: String = ""
    var countryCode: String = ""
    var isApiRunning =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    deinit {
        self.removeKeyboardNotifications()
    }
    
    // MARK: - Private functions
    private func setup() {
        self.registerKeyboardNotifications()
        self.recheckVM()
        self.addTapGesture()
        self.setupPhoneNumber()
        self.txtFieldFirst.becomeFirstResponder()
        arrayTextField = [txtFieldFirst, txtFieldSecond, txtFieldThird, txtFieldFourth]
        for textField in arrayTextField {
            textField.autocorrectionType = .no
            textField.keyboardType = .phonePad
            textField.delegate = self
        }
        self.viewsOTP[0].layer.borderColor = UIColor.appOrangeColor.cgColor
        self.txtFieldFirst.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDoneFirst), target: self)
        self.txtFieldSecond.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDoneSecond), target: self)
        self.txtFieldThird.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDoneThird), target: self)
        self.txtFieldFourth.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDoneFourth), target: self)
        
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = VerifyPhoneVM()
        }
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private func setupPhoneNumber() {
        let strPhone = "Sent to ".localize() + "\(countryCode) " + phoneNumber
        self.lblPhoneNumber.text = strPhone
    }
    
    private func updateMobileNumber() {
        if let user = Defaults[.user] {
            user.mobileNumber = phoneNumber
            user.isPhoneVerified = 1
            Defaults[.user] = user
        }
    }
    
    private func verifyOTP() {
        
        print("Verify OTP")
        if let firstDigit = self.txtFieldFirst.text, let secondDigit = self.txtFieldSecond.text, let thirdDigit = self.txtFieldThird.text, let fourthDigit = self.txtFieldFourth.text {
            if let vM = self.viewModel, vM.validateOTP(firstDigit: firstDigit, secondDigit: secondDigit, thirdDigit: thirdDigit, fourthDigit: fourthDigit) {
                let otp = firstDigit + secondDigit + thirdDigit + fourthDigit
                print("Otp is \(otp)")
                
                if isApiRunning {
                    return
                }
                isApiRunning =  true
                self.viewModel?.requestToVerifyPhone(phone: phoneNumber, otp: otp, completion: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.updateMobileNumber()
                        strongSelf.isApiRunning = false
                        if UserSession.sharedSession.guestCheckout {
                            strongSelf.handleGuestCheckout()
                            return
                        }
                        
                        if strongSelf.isUpdatePhone, let navC = strongSelf.navigationController {
                            let viewControllers: [UIViewController] = navC.viewControllers as [UIViewController]
                            if let viewC = viewControllers[viewControllers.count - 3] as? EditProfileViewC {
                                viewC.updatePhone()
                            }
                            navC.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        } else {
                            
//                            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Your registration is successful. Please verify your email id to sign in.".localize(), completeion_: { (success) in
//                                if success {
//                                    AppDelegate.delegate.showEmptyProfile()
//                                }
//                            })
                            AppDelegate.delegate.showHome()
                        }
                    }
                    
                })
            }
        }
    }

    
    private func updatedBorderColor(index: OTPView) {
        for subView in self.viewsOTP {
            subView.layer.borderColor = UIColor.borderColor.cgColor
        }
        self.viewsOTP[index.rawValue].layer.borderColor = UIColor.appOrangeColor.cgColor
    }
    
    private func clearOtpFields() {
        self.txtFieldFirst.text = ""
        self.txtFieldSecond.text = ""
        self.txtFieldThird.text = ""
        self.txtFieldFourth.text = ""
        self.txtFieldFirst.becomeFirstResponder()
        self.updatedBorderColor(index: .first)
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
    
    fileprivate func moveFarwordDirection(textField: UITextField, isForward: Bool) {
        
        switch textField {
        case self.txtFieldFirst:
            if isForward {
                self.txtFieldSecond.becomeFirstResponder()
                self.updatedBorderColor(index: .second)
            }
        case self.txtFieldSecond:
            if isForward {
                self.txtFieldThird.becomeFirstResponder()
                self.updatedBorderColor(index: .third)
            } else {
                self.txtFieldFirst.becomeFirstResponder()
                self.updatedBorderColor(index: .first)
            }
        case self.txtFieldThird:
            if isForward {
                self.txtFieldFourth.becomeFirstResponder()
                self.updatedBorderColor(index: .fourth)
            } else {
                self.txtFieldSecond.becomeFirstResponder()
                self.updatedBorderColor(index: .second)
            }
        case self.txtFieldFourth:
            if isForward {
                self.verifyOTP()
            } else {
                self.txtFieldThird.becomeFirstResponder()
                self.updatedBorderColor(index: .third)
            }
        default: break
        }
    }
    
    //MARK: - Selector Methods
    @objc func tapView() {
        self.view.endEditing(true)
    }
    
    // MARK: - Notifications
    private func registerKeyboardNotifications() {
        //Adding noti. on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        Threads.performTaskInMainQueue {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            if let height = keyboardSize?.height {
                self.constraintBottomVerifyButton.constant = height - 50
                var frame = self.view.frame
                frame.origin.y = -50
                //self.view.frame = frame
                if Constant.screenWidth == 320.0 {
                  self.cnstTopVerifyPhone.constant = 5
                } else if Constant.screenWidth == 375.0 {
                    self.cnstTopVerifyPhone.constant = 20
                }
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func tapDoneFirst() {
        self.txtFieldFirst.resignFirstResponder()
    }
    
    @objc func tapDoneSecond() {
        self.txtFieldSecond.resignFirstResponder()
    }
    
    @objc func tapDoneThird() {
        self.txtFieldThird.resignFirstResponder()
    }
    
    @objc func tapDoneFourth() {
        self.txtFieldFourth.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.constraintBottomVerifyButton.constant = bottomHt
        var frame = self.view.frame
        frame.origin.y = 0
        self.view.frame = frame
        self.cnstTopVerifyPhone.constant = 33
        self.view.updateConstraintsIfNeeded()
    }
    // MARK: - IBAction functions
    
    @IBAction func tapResendOtp(_ sender: UIButton) {
        self.viewModel?.requestToSendOtp(phone: self.phoneNumber, countryCode: self.countryCode, completion: { (success) in
            if success {
                self.clearOtpFields()
                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "New otp has been sent to your number".localize())
            }
        })
    }
    
    @IBAction func tapVerifyOTP(_ sender: UIButton) {
        self.verifyOTP()
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OTPViewC: UITextFieldDelegate, AVTextDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let tag = textField.tag - 1
        if let optIndex = OTPView(rawValue: tag) {
            self.updatedBorderColor(index: optIndex)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            textField.text = ""
            self.moveFarwordDirection(textField: textField, isForward: false)
        } else {
            textField.text = string
            self.moveFarwordDirection(textField: textField, isForward: true)
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtFieldFirst {
            self.txtFieldSecond.becomeFirstResponder()
            return false
        } else if textField == self.txtFieldSecond {
            self.txtFieldThird.becomeFirstResponder()
            return false
        } else if textField == self.txtFieldThird {
            self.txtFieldFourth.becomeFirstResponder()
            return false
        } else if textField == self.txtFieldThird {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func backspacePressed(textField: UITextField) {
        self.moveFarwordDirection(textField: textField, isForward: false)
    }
}
