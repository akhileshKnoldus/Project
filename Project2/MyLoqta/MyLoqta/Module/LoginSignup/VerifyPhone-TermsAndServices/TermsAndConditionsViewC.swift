//
//  TermsAndConditionsViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Foundation

class TermsAndConditionsViewC: BaseViewC {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var viewIAgree: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -  Private functions
    
    private func setup() {
        self.recheckVM()
        self.loadUrl()
    }
    
    private func recheckVM() {
        
    }
    
    private func loadUrl() {
        let urlString = Constant.termsAndConditionUrl
        if let url = URL(string: urlString) {
            let requestObj = URLRequest(url: url)
            webView.loadRequest(requestObj)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: Any) {
        if let navC = self.navigationController, navC.viewControllers.count > 1 {
            UserSession.sharedSession.clearDataOfUserSession()
            navC.popViewController(animated: true)
        } else {
            UserSession.sharedSession.clearDataOfUserSession()
            AppDelegate.delegate.showEmptyProfile()
        }
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapIAgree(_ sender: UIButton) {
        if let phoneVC = DIConfigurator.sharedInst().getVerifyPhone() {
            self.navigationController?.pushViewController(phoneVC, animated: true)
        }
    }
}
    
    
//    // MARK: - Private functions
//
//    private func setup() {
//
//        var frame = self.viewIAgree.frame
//        frame.size.width = Constant.screenWidth
//        frame.size.height = 88 * Constant.htRation
//        self.viewIAgree.frame = frame
//        self.tblViewTermsAndCond.allowsSelection = false
//       // self.tblViewTermsAndCond.tableFooterView = self.viewIAgree
//    }
//
//    fileprivate func getTermsAndConditions() -> NSMutableAttributedString {
//
//        let attributedString = NSMutableAttributedString(string: "Effective April 10th, 2018\n\nCompleting the registration process and submitting payment constitutes an agreement on your part to accept the following terms and conditions.\n\nRegistration Types\n\nYou agree to pay in full the fee that is applicable to your registration category. For example, current full-time students possessing valid student identification are entitled to register at the student rate. Guest registration for evening events is only available for individuals accompanying a registered conference attendee. Membership discounts are only available to SOTA members in good standing. All other individuals must register at the non-member professional rate.\n\nRegistration Confirmation & Updates\n\nYou will receive your registration confirmation and payment receipt by email. Please ensure that your email address is entered correctly in your account on the registration site.\n\nAttendee check-in at the conference hotel will open on Wednesday, August 1st, 2018. Check-in times, locations, and other details will be announced via email and on the TypeCon website.", attributes: [
//            .font: UIFont.font(name: .SFProText, weight: .Regular, size: FontSize.size_15),
//            .foregroundColor: UIColor(white: 16.0 / 255.0, alpha: 0.7),
//            .kern: -0.28
//            ])
//        attributedString.addAttributes([
//            .font: UIFont.font(name: .SFProText, weight: .SemiBold, size: FontSize.size_15),
//            .foregroundColor: UIColor(white: 16.0 / 255.0, alpha: 1.0),
//            .kern: -0.24
//            ], range: NSRange(location: 0, length: 26))
//        attributedString.addAttributes([
//            .font: UIFont.font(name: .SFProText, weight: .SemiBold, size: FontSize.size_15),
//            .foregroundColor: UIColor(white: 16.0 / 255.0, alpha: 1.0)
//            ], range: NSRange(location: 172, length: 18))
//        attributedString.addAttributes([
//            .font: UIFont.font(name: .SFProText, weight: .SemiBold, size: FontSize.size_15),
//            .foregroundColor: UIColor(white: 16.0 / 255.0, alpha: 1.0)
//            ], range: NSRange(location: 668, length: 35))
//        return attributedString
//    }
//
//    // MARK: - IBAction functions
//
//    @objc @IBAction func tapIAgree(_ sender: Any) {
//
//        if let phoneVC = DIConfigurator.sharedInst().getVerifyPhone() {
//            self.navigationController?.pushViewController(phoneVC, animated: true)
//        }
//    }
//    @IBAction func tapBack(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//
//extension TermsAndConditionsViewC: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let viewFooter = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: (88.0 * Constant.htRation)))
//        let buttonIAgree = AVButton(frame: CGRect(x: 16, y: 19, width: Constant.screenWidth - 32, height: viewFooter.frame.size.height - 38))
//        buttonIAgree.localizeKey = "I'm Agree"
//        buttonIAgree.addTarget(self, action: #selector(tapIAgree(_:)), for: .touchUpInside)
//        buttonIAgree.conrnerRadius = CGFloat(8)
//        buttonIAgree.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Medium, size: FontSize.size_15)
//        viewFooter.addSubview(buttonIAgree)
//        return viewFooter
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return (Constant.htRation * 88.0)
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        if let label = cell.contentView.viewWithTag(1) as? UILabel {
//            label.attributedText = self.getTermsAndConditions()
//        }
//        return cell
//    }
//}
