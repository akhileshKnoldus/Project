//
//  SellerSoldProductsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerSoldProductsViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var tblViewOrders: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: SellerSoldProductsVModeling?
    var arrSoldProducts = [Product]()
    var pageToLoad = 1
    var totalProducts = 0
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
        self.initializeRefresh()
        self.getSoldOrdersList(page: 1)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerSoldProductsVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewOrders.allowsSelection = true
        self.tblViewOrders.separatorStyle = .none
        self.tblViewOrders.delegate = self
        self.tblViewOrders.dataSource = self
    }
    
    private func registerCell() {
        self.tblViewOrders.register(SoldProductsCell.self)
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewOrders.refreshControl = refresh
    }
    
    //MARK: - Public Methods
    func loadMoreData() {
        self.pageToLoad += 1
        self.getSoldOrdersList(page: self.pageToLoad)
    }
    
    func pushToFeedbackView(orderDetailId: Int) {
        if let feedbackVC = DIConfigurator.sharedInst().getSellerFeedbackViewC() {
            feedbackVC.orderDetailId = orderDetailId
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    //MARK: - APIMethods
    func getSoldOrdersList(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.requestGetSellerSoldOrdersList(page: page, isShowLoader: isShowLoader, completion: { [weak self] (productList, productsCount) in
            guard let strongSelf = self else { return }
            if strongSelf.pageToLoad == 1 {
                strongSelf.totalProducts = productsCount
                strongSelf.arrSoldProducts.removeAll()
            }
            strongSelf.arrSoldProducts.append(contentsOf: productList)
            strongSelf.tblViewOrders.reloadData()
            
            strongSelf.viewNoData.isHidden = strongSelf.arrSoldProducts.count > 0 ? true : false
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        self.getSoldOrdersList(page: self.pageToLoad, isShowLoader: false)
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
