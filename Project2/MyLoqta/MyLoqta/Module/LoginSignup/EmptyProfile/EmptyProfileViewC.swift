//
//  EmptyProfileViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 04/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import Firebase
import GoogleSignIn
import SwiftyUserDefaults


let cornerRadius = CGFloat(8.0)

class EmptyProfileViewC: BaseViewC {

    @IBOutlet weak var lblUnlockFullExp: AVLabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var lblGoogle: UILabel!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var viewGoogle: UIView!
    @IBOutlet weak var viewFacebook: UIView!
    var viewModel: EmptyProfileVModeling?
    var isGuest: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        GIDSignIn.sharedInstance().signOut()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private functions
    private func setup() {
        
        self.recheckVM()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.hideTransparentNavigationBar()
        self.viewModel?.socialDelegate = self
        self.view.bringSubview(toFront: self.containerView)
        self.viewGoogle.roundCorners(cornerRadius)
        self.viewFacebook.roundCorners(cornerRadius)
        self.btnCreateAccount.roundCorners(cornerRadius)
        self.setLocalization()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = EmptyProfileVM()
        }
    }
    
    private func setLocalization() {
        //lblUnlockFullExp.text = "Unlock the full experience".localize()
        //lblDesc.text = "Sign in to save your favourite items and see personalised recommendations".localize()
        btnSignin.setTitle("Sign in".localize(), for: .normal)
        btnCreateAccount.setTitle("Create account".localize(), for: .normal)
        lblGoogle.text = "Google".localize()
        lblFacebook.text = "Facebook".localize()
    }
    
    // MARK: - IBActions
    @IBAction func tapCreateAccount(_ sender: Any) {
    }
    
    @IBAction func tapSignin(_ sender: Any) {
        
        if let loginVC = DIConfigurator.sharedInst().getLoginVC() {
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @IBAction func tapCross(_ sender: Any) {
        if isGuest {
            self.navigationController?.dismiss(animated: true, completion: nil)
        } else {
            AppDelegate.delegate.showHome()
        }
    }
    
    @IBAction func tapGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tapFacebook(_ sender: Any) {
        self.viewModel?.facebookLogin(fromVC: self)
    }
    
}

// MARK: - Google delegate

extension EmptyProfileViewC: GIDSignInDelegate, GIDSignInUIDelegate, SocialSignupDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            self.viewModel?.processGoogleLogingResponse(user: user)
        }
    }
    
    func socialSignupCompeted() {
        
        if let user = Defaults[.user], let phoneVerified = user.isPhoneVerified {
            if phoneVerified == 1 {
                AppDelegate.delegate.showHome()
            } else {                
                if let termCondVC = DIConfigurator.sharedInst().getTermsAndCondVC() {
                    self.navigationController?.pushViewController(termCondVC, animated: true)
                }
            }
        }
    }
}
