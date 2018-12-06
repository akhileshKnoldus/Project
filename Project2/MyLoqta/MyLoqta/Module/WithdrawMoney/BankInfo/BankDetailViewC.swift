//
//  BankDetailViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class BankDetailViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var tblViewBank: UITableView!
    
    //MARK: - Variables
    var viewModel: WithdrawMoneyVModeling?
    var strBankName = ""
    var strIBAN = ""

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
        self.setupTableStyle()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        self.getBankDetails()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = WithdrawMoneyVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewBank.register(AddNewAddressCell.self)
        self.tblViewBank.delegate = self
        self.tblViewBank.dataSource = self
        self.tblViewBank.allowsSelection = false
        self.tblViewBank.separatorStyle = .none
    }
    
    private func getBankDetails() {
        if let user = Defaults[.user], let seller = user.seller, let ibanNumber = seller.ibanNumber, let bankName = seller.bankName {
            self.strIBAN = ibanNumber
            self.strBankName = bankName
            self.tblViewBank.reloadData()
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension BankDetailViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddNewAddressCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        switch indexPath.row {
        case 0:
            cell.configureCellForBankInfo(title: "Bank name".localize(), value: self.strBankName)
        case 1:
            cell.configureCellForBankInfo(title: "IBAN", value: self.strIBAN)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
