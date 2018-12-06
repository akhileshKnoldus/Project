//
//  WithdrawMoneyViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class WithdrawMoneyViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var lblWalletBalance: AVLabel!
    @IBOutlet weak var lblWithdrawAmount: AVLabel!
    @IBOutlet weak var tblViewWithdraw: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: WithdrawMoneyVModeling?
    var arrayWithdraws = [Withdraw]()
    var currentBalance: Float = 0.0
    var requestedAmount = 0
    var pageToLoad = 1
    let refresh = UIRefreshControl()

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
        self.setupTableStyle()
        self.initializeRefresh()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        self.getWithdrawList(page: 1)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = WithdrawMoneyVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewWithdraw.register(WithdrawMoneyTableCell.self)
        self.tblViewWithdraw.dataSource = self
        self.tblViewWithdraw.delegate = self
        self.tblViewWithdraw.allowsSelection = false
        self.tblViewWithdraw.separatorStyle = .none
    }
    
    private func setupBalanceData() {
        let usWalletBalance = self.currentBalance.withCommas()
        let usRequestAmount = self.requestedAmount.withCommas()
        self.lblWalletBalance.text = "\(usWalletBalance) " + "KD".localize()
        self.lblWithdrawAmount.text = "Withdrawal Amount Requested: " + "\(usRequestAmount) " + "KD".localize()
    }
    
    private func didPerformActionOnWithdraw() {
        if let popupVC = DIConfigurator.sharedInst().getWithdrawPopupViewC() {
            popupVC.delegate = self
            popupVC.currentBalance = self.currentBalance
            self.present(popupVC, animated: true, completion: nil)
        }
    }
    
    private func didPerformActionOnBankInfo() {
        if let bankDetailVC = DIConfigurator.sharedInst().getBankDetailViewC() {
            self.navigationController?.pushViewController(bankDetailVC, animated: true)
        }
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewWithdraw.refreshControl = refresh
    }
    
    //MARK: - API Methods
    private func getWithdrawList(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.requestGetWithdrawRequestList(page: page, isShowLoader: isShowLoader, completion: {[weak self] (arrayWithdraws, currentBalance, requestAmount) in
            guard let strongSelf = self else { return }
            if page == 1 {
                strongSelf.arrayWithdraws.removeAll()
                strongSelf.currentBalance = Float(currentBalance)
                strongSelf.requestedAmount = Int(requestAmount)
                strongSelf.setupBalanceData()
            } 
            strongSelf.arrayWithdraws = strongSelf.arrayWithdraws + arrayWithdraws
            strongSelf.tblViewWithdraw.reloadData()
            //NoDataView
            strongSelf.viewNoData.isHidden = strongSelf.arrayWithdraws.count > 0 ? true : false
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        self.getWithdrawList(page: self.pageToLoad, isShowLoader: false)
    }
    
    //MARK: - Public Methods
    func loadMoreData() {
        self.pageToLoad += 1
        self.getWithdrawList(page: self.pageToLoad)
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapInfo(_ sender: UIButton) {
        self.didPerformActionOnBankInfo()
    }
    
    @IBAction func tapWithdrawMoney(_ sender: UIButton) {
        if self.currentBalance < 10 {
            return
        }
        self.didPerformActionOnWithdraw()
    }
}
