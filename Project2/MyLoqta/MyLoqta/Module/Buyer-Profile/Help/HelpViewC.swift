//
//  HelpViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/3/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class HelpViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnMessage: UIButton!
    
    //MARK: - Variables
    var viewModel: HelpVModeling?
    var arrayNumber = [Phone]()
    var arrayPhoneData = [[String: Any]]()
    
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
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupButtonView()
        self.getNumberList()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = HelpVM()
        }
    }
    
    private func setupButtonView() {
        self.btnCall.setTitle("Make a call".localize(), for: .normal)
        self.btnCall.layer.cornerRadius = 8
        self.btnCall.layer.borderWidth = 1.0
        self.btnCall.layer.borderColor = UIColor.grayBorderColor.cgColor
        self.btnMessage.setTitle("Send a message".localize(), for: .normal)
        self.btnMessage.layer.cornerRadius = 8
        self.btnMessage.layer.borderWidth = 1.0
        self.btnMessage.layer.borderColor = UIColor.grayBorderColor.cgColor
    }
    
    private func pushToMessageView() {
        if let messageVC = DIConfigurator.sharedInst().getMessageAdminViewC() {
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
    }
    
    private func getFormattedPhoneData() {
        for phone in arrayNumber {
            if let countryCode = phone.countryCode, let phNumber = phone.mobileNumber {
                let phoneNumber = countryCode + " " + phNumber
                let phoneData = [Constant.keys.kTitle: phoneNumber, Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
                self.arrayPhoneData.append(phoneData)
            }
        }
    }
    
    private func showPhoneNumberList() {
        let actionItems = self.arrayPhoneData
        Alert.showAlertSheetWithColor(title: nil, message: nil, actionItems: actionItems, showCancel: true) { (action) in
            if let phoneNumber = action.title {
               self.openDialPad(number: phoneNumber)
            }
        }
    }
    
    private func openDialPad(number: String) {
        let array = number.components(separatedBy: " ")
        if array.count > 1, let url = URL(string: "tel://\(array[1])"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    //MARK: - APIMethods
    private func getNumberList() {
        self.viewModel?.requestGetNumberList(completion: {[weak self] (arrayNumber) in
            guard let strongSelf = self else { return }
            strongSelf.arrayNumber = arrayNumber
            strongSelf.getFormattedPhoneData()
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapMakeCall(_ sender: UIButton) {
        self.showPhoneNumberList()
    }
    
    @IBAction func tapSendMessage(_ sender: UIButton) {
       self.pushToMessageView()
    }
}
