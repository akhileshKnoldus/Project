//
//  ResetPasswordViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 06/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ResetPasswordViewC: BaseViewC {

    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var cnstBottomResetBtn: NSLayoutConstraint!
    
    let bottomHt = CGFloat(0)
    var strEmail = ""
    var viewModel: ResetPasswordVModeling?
    
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
        self.removeKeyboardNotifications()
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.registerKeyboardNotifications()
        self.txtFieldEmail.autocorrectionType = .no
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ResetPasswordVM()
        }
    }
    
    private func resetPassword() {
        if let viewModel = self.viewModel, viewModel.validateData(email: strEmail) {
            self.viewModel?.requestToForgotPassword(email: strEmail, completion: { (success) in
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "A reset password link has been sent to your registered email id.".localize(), completeion_: { (success) in
                    if success {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            })
        }
    }
    // MARK: - IBAction functions
    
    @IBAction func tapCross(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapReset(_ sender: Any) {
        self.resetPassword()
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
                self.cnstBottomResetBtn.constant = height
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.cnstBottomResetBtn.constant = bottomHt
        self.view.updateConstraintsIfNeeded()
    }
}

extension ResetPasswordViewC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            self.strEmail = finalText
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.resetPassword()
        return true
    }
}
