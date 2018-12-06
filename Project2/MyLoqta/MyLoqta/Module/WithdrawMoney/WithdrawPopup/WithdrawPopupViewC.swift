//
//  WithdrawPopupViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol WithdrawPopupDelegate: class {
    func didWithdrawSuccess()
}

class WithdrawPopupViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var lblCurrentBalance: AVLabel!
    @IBOutlet weak var tblViewPopup: UITableView!
    
    //MARK: - Variables
    weak var delegate: WithdrawPopupDelegate?
    var viewModel: WithdrawPopupVModeling?
    var currentBalance: Float = 0.0
    var requestAmount = 0
    var requestType = 2
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        self.tblViewPopup.reloadData()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        let usCurrentBalance = self.currentBalance.withCommas()
        self.lblCurrentBalance.text = "\(usCurrentBalance) " + "KD".localize()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = WithdrawPopupVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewPopup.delegate = self
        self.tblViewPopup.dataSource = self
        self.tblViewPopup.separatorStyle = .none
        self.tblViewPopup.allowsSelection = false
    }
    
    private func registerCell() {
        self.tblViewPopup.register(PopupHeaderCell.self)
        self.tblViewPopup.register(PopupPriceCell.self)
        self.tblViewPopup.register(WithdrawButtonCell.self)
    }
    
    func showWithdrawSuccessPopup() {
        if let popupVC = DIConfigurator.sharedInst().getWithdrawSuccessViewC() {
            popupVC.modalPresentationStyle = .overCurrentContext
            popupVC.view.backgroundColor = UIColor.presetedBgColor
            popupVC.delegate = self
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - API Methods
    private func requestWithdraw() {
        let param: [String: AnyObject] = ["requestAmount": self.requestAmount as AnyObject, "requestType": self.requestType as AnyObject]
        self.viewModel?.requestToWithdrawMoney(param: param, completion: { [weak self] (success) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.showWithdrawSuccessPopup()
            }
        })
    }
    
    //MARK: - Public Methods
    func showWithdrawPopup() {
        Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Are you sure you want to withdraw?".localize(), actionTitle: "Yes, I'm".localize(), showCancel: true, action: { (action) in
            self.requestWithdraw()
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - WithdrawSuccessDelegate
extension WithdrawPopupViewC: WithdrawSuccessDelegate {
    func didPerformActionOnDoneButton() {
        if let delegate = self.delegate {
            delegate.didWithdrawSuccess()
            Threads.performTaskInMainQueue {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

