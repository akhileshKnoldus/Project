//
//  ActivityViewC.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ActivityViewC: BaseViewC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblViewActivity: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: ActivityVModeling?
    var arrayDataSource = [[ActivityNotificationsData]]()
    var pageToLoad = 1
    let refresh = UIRefreshControl()

    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.registerCell()
        self.initializeRefresh()
        self.getNotificationsList(page: 1)
    }
    
    private func registerCell() {
        self.tblViewActivity.register(AcceptRejectActivityTableCell.self)
        self.tblViewActivity.register(LeaveFeedbackActivityTableCell.self)
        self.tblViewActivity.register(ProductListingActivityTableViewCell.self)
        self.tblViewActivity.register(TrackStatusActivityTableCell.self)
        self.tblViewActivity.register(FollowingActivityTableCell.self)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ActivityVM()
        }
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewActivity.refreshControl = refresh
    }
    
    //MARK: - API Methods
    func getNotificationsList(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.requestGetNotificationList(page: page, isShowLoader: isShowLoader, completion: { [weak self] (notificationList) in
            guard let strongSelf = self else { return }
            if let arrDataSource = strongSelf.viewModel?.getDataSourceForActivity(arrActivities: notificationList) {
                if page == 1 {
                    strongSelf.arrayDataSource.removeAll()
                    strongSelf.arrayDataSource = arrDataSource
                    strongSelf.viewNoData.isHidden = notificationList.count > 0 ? true : false
                } else {
                    strongSelf.arrayDataSource[0] = strongSelf.arrayDataSource[0] + arrDataSource[0]
                    strongSelf.arrayDataSource[1] = strongSelf.arrayDataSource[1] + arrDataSource[1]
                }
            }
            strongSelf.tblViewActivity.reloadData()
        })
    }
    
    func requestAcceptOrder(orderDetailId: Int) {
        let type = 2
        self.viewModel?.requestToAcceptOrder(orderDetailId: orderDetailId, type: type, completion: { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.pageToLoad = 1
            strongSelf.getNotificationsList(page: strongSelf.pageToLoad)
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        self.getNotificationsList(page: self.pageToLoad, isShowLoader: false)
    }
    
    //MARK: - Public Methods
    func loadMoreData() {
        self.pageToLoad += 1
        self.getNotificationsList(page: self.pageToLoad)
    }
    
    func pushToRejectReason(orderDetailId: Int) {
        if let rejectVC = DIConfigurator.sharedInst().getRejectReasonViewC() {
            rejectVC.orderDetailId = orderDetailId
            rejectVC.delegate = self
            rejectVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(rejectVC, animated: true)
        }
    }
    
    func pushToFeedbackView(orderDetailId: Int) {
        if let feedbackVC = DIConfigurator.sharedInst().getSellerFeedbackViewC() {
            feedbackVC.orderDetailId = orderDetailId
            feedbackVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    func pushToMyOrdersScreen() {
        if let buyerOrderListViewC = DIConfigurator.sharedInst().getBuyerOrderListViewC() {
            buyerOrderListViewC.isFromMyOrders = false
            buyerOrderListViewC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(buyerOrderListViewC, animated: true)
        }
    }
    
    func moveToBuyerOrderDetail(indexPath: IndexPath) {
        let activity = self.arrayDataSource[1][indexPath.row].activity
        guard let orderDetailId = activity.orderDetailId else { return }
        if let orderDVC = DIConfigurator.sharedInst().getOrderDetailVC() {
            orderDVC.orderId = orderDetailId
            orderDVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(orderDVC, animated: true)
        }
    }
}
