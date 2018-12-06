//
//  UpdatePasswordViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class UpdatePasswordViewC: BaseViewC {

    @IBOutlet weak var cnstBottomUpdateButton: NSLayoutConstraint!
    @IBOutlet weak var btnUpdatePassword: AVButton!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var viewModel: UpdatePasswordVModeling?
    var userId: String?
    var token: String?
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
        self.txtPassword.autocorrectionType = .no
        self.txtConfirmPassword.autocorrectionType = .no
        self.txtPassword.isSecureTextEntry = true
        self.txtConfirmPassword.isSecureTextEntry = true
        self.registerForKeyboardNotifications()
        
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = UpdatePasswordVM()
        }
    }
    
    // MARK: - IBAction functions
    @IBAction func tapUpdatePassword(_ sender: Any) {
    
        
        self.view.endEditing(true)
        
        if let text = self.txtPassword.text, text.isEmpty {
            
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter new password".localize())
            return
            
        } else if let text = self.txtPassword.text, ( text.utf8.count < Constant.validation.kPasswordMin || text.utf8.count > Constant.validation.kPasswordMax ) {
            
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "The password should contain minimum \(Constant.validation.kPasswordMin) and maximum \(Constant.validation.kPasswordMax) characters.".localize())
            return
            
        } else if let text = self.txtConfirmPassword.text, text.isEmpty {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter confirm password".localize())
            return
            
        } else if let pass = self.txtPassword.text, let cnfrmPass = self.txtConfirmPassword.text, pass != cnfrmPass {
            
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Password and confirm password should same".localize())
            return
        }
        
        if let userIdValue = self.userId, let tokenValue = self.token, let password = self.txtPassword.text {
            let param = ["passwordToken": tokenValue as AnyObject,
                         "confirmPassword": password as AnyObject,
                         "userId": userIdValue as AnyObject]
            self.viewModel?.resetPassword(param: param, completion: { [weak self] in
                guard let _ = self else { return }
                AppDelegate.delegate.showEmptyProfile()
            })
        }
    }
    
    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    // MARK: - Notifications
    
    @objc func keyboardDidShow(notification: NSNotification) {
        Threads.performTaskInMainQueue {
            var info = notification.userInfo!
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            if let height = keyboardSize?.height {
                self.cnstBottomUpdateButton.constant = height
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.cnstBottomUpdateButton.constant = 0
        self.view.updateConstraintsIfNeeded()
    }
    
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

extension UpdatePasswordViewC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    
}
