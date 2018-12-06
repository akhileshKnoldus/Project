//
//  CustomAlertView.swift
//  OneNation
//
//  Created by Shilpa on 07/11/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import UIKit

class CustomAlertView: UIView {

    //Create Topic
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var viewGradient: AVView!
    
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var txtViewReply: UITextView!
    @IBOutlet weak var imgViewProduct: UIView!
    @IBOutlet weak var lbllQuestion: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    @IBOutlet weak var centerYTopicCnst: NSLayoutConstraint!
    
    var handler : ((Any) -> Void)!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    deinit {
        self.removeKeyboardNotifications()
    }
    
    // MARK: -  Keyboard Notification Observers
    private func registerForKeyboardNotifications()
    {
        //Adding noti. on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func finishEditing() {
        self.endEditing(true)
    }

    @objc func keyboardWasShown(notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            if let keyboardSize: CGSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
                Threads.performTaskInMainQueue {
                    self.centerYTopicCnst.constant = -100
                    self.updateConstraints()
                    UIView.animate(withDuration: 0.2, delay: 0.0, options: .allowAnimatedContent, animations: { () -> Void in
                        self.layoutIfNeeded()
                    }, completion: nil)
                    
                }
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification)
    {
        self.centerYTopicCnst.constant = 0
        self.updateConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadView(productImage : String, productName : String = "", question: String = "", eventHandler: ((Any) -> Void)?) {
        registerForKeyboardNotifications()
        
        let arrView = Bundle.main.loadNibNamed("CustomAlert", owner: self, options: nil)
        let replyView = arrView![0] as! UIView
        replyView.frame = self.bounds
        addSubview(replyView)
        
        self.viewPopup.layer.borderWidth = 2.0
        self.viewPopup.layer.borderColor = UIColor.gray.cgColor
        self.txtViewReply.layer.borderWidth = 1.0
        self.txtViewReply.layer.borderColor = UIColor.gray.cgColor
        
        Threads.performTaskAfterDealy(0.05) {
            self.viewGradient.drawGradientWithRGB(startColor: UIColor.lightOrangeGradientColor, endColor: UIColor.darkOrangeGradientColor)
        }
        
        self.lblProductName.text = "Nokia Phone"
//        btnCancel.setTitle(firstBtnTitle.localizedString, for: .normal)
//        btnCreate.setTitle(secondBtnTitle.localizedString, for: .normal)
//        btnCreate.dropShadow(color: UIColor.lightGray, opacity: 3.0, offSet: CGSize(width: 10, height: 10) , radius: 5, scale: true)
//        btnCancel.dropShadow(color: UIColor.lightGray, opacity: 3.0, offSet: CGSize(width: 10, height: 10) , radius: 5, scale: true)
//        txtDiscussion.placeholder = ConstantTexts.enterDiscussionTopic.localizedString
//        txtDiscussion.addToolbarWithButtonTitled(title: ConstantTexts.done.localizedString, forTarget: self, selector: #selector(finishEditing))
//        txtDiscussion.delegate = self
//        if Constant.isRightToLeftDirection {
//            txtDiscussion.textAlignment = .right
//        } else {
//            txtDiscussion.textAlignment = .left
//        }
//        imgUperDiscsn.image = UIImage(named: image.rawValue)
//        viewRound.roundCorners(borderWidth: 0, borderColor: UIColor.clear.cgColor, cornerRadius: viewRound.frame.size.width/2)
        
        handler = eventHandler
    }
    
    //MARK: - IBAction
    
    @IBAction func tapCreate(_ sender: UIButton) {
        self.endEditing(true)
        if (self.handler != nil) {
//            if txtDiscussion.text == "" {
//                TAAlert.showOkAlert(title: ConstantTexts.AppName.localizedString, message: ConstantTexts.enterTopicName.localizedString)
//            } else {
//                self.handler(["type" : AlertButtonType.create, "param" : ["topicName" : txtDiscussion.text ?? "", "shareAs" : shareAs]])
//            }
        }
    }
    
}

extension CustomAlertView : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
//        if Constant.isRightToLeftDirection {
//            textView.textAlignment = .right
//        } else {
//            textView.textAlignment = .left
//        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
        }
        let newLength = (textView.text?.count)! + text.count - range.length
        if textView == txtViewReply {
            if newLength > 60 {
                return false
            }
        }
        return true
    }
}

extension UIButton {
    
    func addShadow() {
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 3.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
    }
    
}
