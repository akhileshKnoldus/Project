//
//  BuyerFeedbackViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BuyerFeedbackViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewFeedback: UITableView!
    
    //MARK: - Variables
    var viewModel: BuyerFeedbackVModeling?
    var dataSource = [[String: Any]]()
    var orderDetailId = 0
    
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
        if let dataSourc = self.viewModel?.getDataSource() {
            self.dataSource = dataSourc
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BuyerFeedbackVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewFeedback.dataSource = self
        self.tblViewFeedback.delegate = self
        self.tblViewFeedback.allowsSelection = false
        self.tblViewFeedback.separatorStyle = .none
    }
    
    private func registerCell() {
        self.tblViewFeedback.register(RateTableCell.self)
        self.tblViewFeedback.register(ProfileDescriptionCell.self)
        self.tblViewFeedback.register(SaveButtonTableCell.self)
    }
    
    private func popToOrderList() {
        if let arrayVC = self.navigationController?.viewControllers {
            for vc in arrayVC {
                if let buyerVC = vc as? BuyerOrderListViewC {
                    buyerVC.pullToRefresh()
                    self.navigationController?.popToViewController(buyerVC, animated: true)
                } else if let profileVc = vc as? ProfileViewC {
                    profileVc.pullToRefresh()
                    self.navigationController?.popToViewController(profileVc, animated: true)
                }
            }
        }
    }
    
    //MARK: - APIMethods
    func sendFeedback() {
        if let isValidated = self.viewModel?.validateData(self.dataSource), isValidated {
            self.viewModel?.requestToSendFeedback(orderDetailId: self.orderDetailId, arrData: self.dataSource, completion: { (success) in
                self.popToOrderList()
//                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Your feedback is submitted successfully.".localize(), completeion_: { (success) in
//                    self.popToOrderList()
//                })
            })
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapSendFeedback(_ sender: UIButton) {
        self.sendFeedback()
    }
}
