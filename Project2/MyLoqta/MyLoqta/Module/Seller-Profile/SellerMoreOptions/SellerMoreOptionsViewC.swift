//
//  SellerMoreOptionsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerMoreOptionsViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var tblViewMoreOptions: UITableView!
    
    //MARK: - Variables
    var viewModel: SellerMoreOptionsVModeling?
    var arrayData = [SettingData]()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        if let array = self.viewModel?.getDataSource() {
            self.arrayData.append(contentsOf: array)
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerMoreOptionsVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewMoreOptions.separatorStyle = .none
        self.tblViewMoreOptions.delegate = self
        self.tblViewMoreOptions.dataSource = self
    }
    
    private func registerCell() {
        self.tblViewMoreOptions.register(SettingsCell.self)
    }
    
    //MARK: - IBActions
    @IBAction func tapCross(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

//MARK: - TableViewDelegatesAndDataSource
extension SellerMoreOptionsViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.arrayData[indexPath.row]
        cell.configureData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.moveToSoldOrders()
        case 1: self.moveToWithdrawMoney()
        case 2: self.moveToReferralView()
        case 3: self.pushToHelpView()
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func moveToSoldOrders() {
        if let soldOrderVC = DIConfigurator.sharedInst().getSellerSoldProductsViewC() {
            self.navigationController?.pushViewController(soldOrderVC, animated: true)
        }
    }
    
    func pushToHelpView() {
        if let helpVC = DIConfigurator.sharedInst().getHelpViewC() {
            helpVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
    
    func moveToWithdrawMoney() {
        if let withdrawMoneyVC = DIConfigurator.sharedInst().getWithdrawMoneyViewC() {
            self.navigationController?.pushViewController(withdrawMoneyVC, animated: true)
        }
    }
    
    func moveToReferralView() {
        if let referralVC = DIConfigurator.sharedInst().getReferralViewC() {
            self.navigationController?.pushViewController(referralVC, animated: true)
        }
    }
    
//    func addCustomView() {
//        let view = CustomAlertView(frame: self.view.bounds)
//        view.loadView(productImage: "") { (response) in
//            view.removeFromSuperview()
//        }
//        self.view.addSubview(view)
//    }
}
