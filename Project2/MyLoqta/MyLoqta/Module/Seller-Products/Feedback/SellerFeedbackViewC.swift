//
//  SellerFeedbackViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/5/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerFeedbackViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var tblViewFeedback: UITableView!
    
    //MARK: - Variables
    var viewModel: SellerFeedbackVModeling?
    var dataSource = [[String: Any]]()
    var orderDetailId = 0
    var isFromNotification = false
    
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
        if let dataSourc = self.viewModel?.getDataSource() {
            self.dataSource = dataSourc
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerFeedbackVM()
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
                if let sellerVC = vc as? SellerSoldProductsViewC {
                    sellerVC.pullToRefresh()
                    self.navigationController?.popToViewController(sellerVC, animated: true)
                }
                if let activityVC = vc as? ActivityViewC {
                    activityVC.pullToRefresh()
                    self.navigationController?.popToViewController(activityVC, animated: true)
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
        if isFromNotification {
            AppDelegate.delegate.showHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tapSendFeedback(_ sender: UIButton) {
        self.sendFeedback()
    }
}
