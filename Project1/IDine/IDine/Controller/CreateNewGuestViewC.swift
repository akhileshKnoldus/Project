//
//  CreateNewGuestViewC.swift
//  IDine
//
//  Created by Akhilesh Gupta on 03/12/18.
//  Copyright © 2018 appventurez. All rights reserved.
//

import UIKit
import NKVPhonePicker

class CreateNewGuestViewC: UIViewController {
    
    //MARK:- Properties
    
    //MARK:- IBOutlet
    @IBOutlet weak var txtFieldCountryCode: UITextField!
    @IBOutlet weak var txtFieldMembershipNumber: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK:- Private Method
    private func moveToVerifyUser(){
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        if let verifyVC = mainSb.instantiateViewController(withIdentifier: "VerifyUserViewC") as? VerifyUserViewC {
            self.navigationController?.pushViewController(verifyVC, animated: true)
            
        }
    }
    
    //MARK:-Public Method
    
    //MARK:- IBAction
    @IBAction func tappedCountryCode(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "CountriesViewController", bundle: Bundle(for: CountriesViewController.self))
        let countryViewController = storyBoard.instantiateViewController(withIdentifier: "CountryPickerVC") as! CountriesViewController
        countryViewController.delegate = self as! CountriesViewControllerDelegate
        let navVC = UINavigationController(rootViewController: countryViewController)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func tappedSubmitBtn(_ sender: Any) {
        moveToVerifyUser()
    }
    
    @IBAction func tapInfoBtn(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let infoViewC = sb.instantiateViewController(withIdentifier: "MoreInfoTitle") as? MoreInfoTitle
        {
            self.navigationController?.pushViewController(infoViewC, animated: true)
        }
    }
}

extension CreateNewGuestViewC: CountriesViewControllerDelegate {
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
