//
//  BankInfoViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BankInfoViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var tblViewBankInfo: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: AVButton!
    
    //MARK: - Variables
    var viewModel: BankInfoVModeling?
    var sellerType: sellerType = .individual
    var strIbanNumber = ""
    var strBankName = ""
    var bankId = 0
    var arrayDocuments: [[String: Any]] = [[:]]
    var bankList = [[String: Any]]()
    
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
        self.lblTitle.text = sellerType == .individual ? "Individual account".localize() : "Business account".localize()
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        self.getBankList()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BankInfoVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewBankInfo.separatorStyle = .none
        self.tblViewBankInfo.dataSource = self
        self.tblViewBankInfo.delegate = self
    }
    
    private func registerCell() {
        self.tblViewBankInfo.register(BankDescriptionCell.self)
        self.tblViewBankInfo.register(BankNameCell.self)
        self.tblViewBankInfo.register(AccountNumberCell.self)
    }
    
    private func showBankPopup() {
        if self.bankList.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select  Bank".localize(), arrayList: self.bankList as [[String : AnyObject]], keyValue: "bankName") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let bankName = result["bankName"] as? String, let bankId = result["bankId"] as? Int {
                    strongSelf.strBankName = bankName
                    strongSelf.bankId = bankId
                    strongSelf.tblViewBankInfo.reloadData()
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    private func getBankList() {
        self.viewModel?.getBankList(completion: { [weak self] (arrayBanks) in
            guard let strongSelf = self else { return }
            strongSelf.bankList.append(contentsOf: arrayBanks)
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        if let viewModel = self.viewModel, viewModel.validateData(bankName: self.strBankName, ibanNumber: self.strIbanNumber) {
            
            if let prepareProfileVC = DIConfigurator.sharedInst().getPrepareProfileVC(arrayDocuments: self.arrayDocuments){
                prepareProfileVC.sellerType = self.sellerType
                prepareProfileVC.bankId = self.bankId
                prepareProfileVC.ibanNumber = self.strIbanNumber
                self.navigationController?.pushViewController(prepareProfileVC, animated: true)
            }
        }
    }
}

extension BankInfoViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getBankDescriptionCell(indexPath, tableView: tableView)
        case 1:
            return getBankNameCell(indexPath, tableView: tableView)
        default:
            return getAccountNumberCell(indexPath, tableView: tableView)
        }
    }
    
    private func getBankDescriptionCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: BankDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    private func getBankNameCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: BankNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.txtFieldBankName.text = self.strBankName
        return cell
    }
    
    private func getAccountNumberCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: AccountNumberCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.txtFieldAccountNumber.text = self.strIbanNumber
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 155.0
        default:
            return 60.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.showBankPopup()
        default:
            return
        }
    }
}

extension BankInfoViewC: AccountNumberCellDelegate {
    
    func accountNumberEntered(_ text: String) {
        self.strIbanNumber = text
    }
}
