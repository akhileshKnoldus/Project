//
//  VerifyUserViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 03/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
import NKVPhonePicker

class VerifyUserViewC: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtFieldMembershipNumber: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldCountryCode: UITextField!
    
    //Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK:- Private Function
    private func moveToOTP(){
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        if let otpVC = mainSb.instantiateViewController(withIdentifier: "OTPVerificationViewC") as? OTPVerificationViewC {
            self.navigationController?.pushViewController(otpVC, animated: true)
            
        }
    }
    
    //MARK:- Public Function
    
    //MARK:- IBAction
    @IBAction func tappedCountryCode(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "CountriesViewController", bundle: Bundle(for: CountriesViewController.self))
        let countryViewController = storyBoard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountriesViewController
        countryViewController.delegate = self as! CountriesViewControllerDelegate
        let navVC = UINavigationController(rootViewController: countryViewController)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedSendOTPBtn(_ sender: Any) {
        moveToOTP()
    }
}

//MARK:- Extension
//extension VerifyUserViewC: CountryPickerDelegate
//{
//    //MARK:- Delegates
//    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//
//    }
//
//
//}

extension VerifyUserViewC: CountriesViewControllerDelegate {
    func countriesViewControllerDidCancel(_ sender: CountriesViewController){
        sender.dismiss(animated: true, completion: nil)
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country){
        sender.dismiss(animated: true, completion: nil)
        //self.imgViewFlag.image = country.flag
        self.txtFieldCountryCode.text = "+"+country.phoneExtension
    }
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country, flagImage:UIImage){
        sender.dismiss(animated: true, completion: nil)
        //self.imgViewFlag.image = flagImage
        self.txtFieldCountryCode.text = "+"+country.phoneExtension
    }
}
