//
//  BuyerOrderListViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/13/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BuyerOrderListViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnActive: UIButton!
    @IBOutlet weak var btnArchive: UIButton!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var tblViewOrders: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: BuyerOrderListVModeling?
    var arrActiveProducts = [Product]()
    var arrArchivedProducts = [Product]()
    var pageToLoad = 1
    var strSearch = ""
    var isFromMyOrders = false
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
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.btnActive.isSelected = true
        self.recheckVM()
        self.setuptableStyle()
        self.initializeRefresh()
        self.btnActive.isSelected = true
        self.txtFieldSearch.autocorrectionType = .no
        self.txtFieldSearch.delegate = self
        self.getActiveOrdersList(search: self.strSearch, page: self.pageToLoad)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BuyerOrderListVM()
        }
    }
    
    private func setuptableStyle() {
        self.registerCell()
        self.tblViewOrders.allowsSelection = true
        self.tblViewOrders.separatorStyle = .none
        self.tblViewOrders.delegate = self
        self.tblViewOrders.dataSource = self
    }
    
    private func registerCell() {
        self.tblViewOrders.register(ArchivedOrderCell.self)
        self.tblViewOrders.register(ActiveOrderCell.self)
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewOrders.refreshControl = refresh
    }
    
    private func moveToMyCartViewC() {
        if let myCartVC = DIConfigurator.sharedInst().getMyCartVC() {
            let navC = UINavigationController(rootViewController: myCartVC)
            myCartVC.hidesBottomBarWhenPushed = true
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Selector Methods
    @objc func requestToSearch(text: String) {
        self.pageToLoad = 1
        self.strSearch = text
        if self.btnActive.isSelected {
            self.getActiveOrdersList(search: self.strSearch, page: self.pageToLoad)
        } else {
            self.getArchivedOrdersList(search: self.strSearch, page: self.pageToLoad)
        }
    }
    
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        if self.btnActive.isSelected {
            self.getActiveOrdersList(search: self.strSearch, page: self.pageToLoad, isShowLoader: false)
        } else {
            self.getArchivedOrdersList(search: self.strSearch, page: self.pageToLoad, isShowLoader: false)
        }
    }
    
    //MARK: - Public Methods
    func loadMoreData() {
        if self.btnActive.isSelected {
            self.pageToLoad += 1
            self.getActiveOrdersList(search: self.strSearch, page: self.pageToLoad)
        } else {
            self.pageToLoad += 1
            self.getArchivedOrdersList(search: self.strSearch, page: self.pageToLoad)
        }
    }
    
    func pushToFeedbackView(orderDetailId: Int) {
        if let feedbackVC = DIConfigurator.sharedInst().getBuyerFeedbackViewC() {
            feedbackVC.orderDetailId = orderDetailId
            feedbackVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    //MARK: - APIMethods
    func getActiveOrdersList(search: String, page: Int, isShowLoader: Bool = true) {
        let orderType = buyerOrderListType.activeProduct.rawValue
        self.viewModel?.requestGetBuyerOrdersList(listType: orderType, search: search, page: page, isShowLoader: isShowLoader, completion: { [weak self] (productList) in
            guard let strongSelf = self else { return }
            if strongSelf.pageToLoad == 1 {
                strongSelf.arrActiveProducts.removeAll()
            }
            strongSelf.arrActiveProducts.append(contentsOf: productList)
            strongSelf.tblViewOrders.reloadData()
            
            strongSelf.viewNoData.isHidden = strongSelf.arrActiveProducts.count > 0 ? true : false
        })
    }
    
    func getArchivedOrdersList(search: String, page: Int, isShowLoader: Bool = true) {
        let orderType = buyerOrderListType.archivedProduct.rawValue
        self.viewModel?.requestGetBuyerOrdersList(listType: orderType, search: search, page: page, isShowLoader: isShowLoader, completion: { [weak self] (productList) in
            guard let strongSelf = self else { return }
            if strongSelf.pageToLoad == 1 {
                strongSelf.arrArchivedProducts.removeAll()
            }
            strongSelf.arrArchivedProducts.append(contentsOf: productList)
            strongSelf.tblViewOrders.reloadData()
            
            strongSelf.viewNoData.isHidden = strongSelf.arrArchivedProducts.count > 0 ? true : false
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        if isFromMyOrders {
            AppDelegate.delegate.showHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func tapCart(_ sender: UIButton) {
        self.moveToMyCartViewC()
    }
    
    @IBAction func tapActive(_ sender: UIButton) {
        self.btnActive.isSelected = true
        self.btnArchive.isSelected = false
        self.pageToLoad = 1
        self.getActiveOrdersList(search: self.strSearch, page: self.pageToLoad)
    }
    
    @IBAction func tapArchived(_ sender: UIButton) {
        self.btnActive.isSelected = false
        self.btnArchive.isSelected = true
        self.pageToLoad = 1
        self.getArchivedOrdersList(search: self.strSearch, page: self.pageToLoad)
    }
}
