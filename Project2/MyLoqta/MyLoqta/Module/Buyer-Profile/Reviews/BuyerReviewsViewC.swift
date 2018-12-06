//
//  BuyerReviewsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/22/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BuyerReviewsViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewReviews: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: BuyerReviewsVModeling?
    var arrReviews = [Reviews]()
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        self.initializeRefresh()
        self.getReviewsList(page: 1)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BuyerReviewsVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewReviews.register(ManageStoreReviewsTableCell.self)
        self.tblViewReviews.delegate = self
        self.tblViewReviews.dataSource = self
        self.tblViewReviews.allowsSelection = false
        self.tblViewReviews.separatorStyle = .none
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        refresh.isHidden = true
        refresh.backgroundColor = .clear
        self.tblViewReviews.refreshControl = refresh
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        self.getReviewsList(page: 1, isShowLoader: false)
    }
    
    //MARK: - Public Methods
    func loadMoreData() {
        self.pageToLoad += 1
        self.getReviewsList(page: self.pageToLoad)
    }
    
    //MARK: - API Methods
    func getReviewsList(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.requestGetMyReviews(page: page, isShowLoader: isShowLoader, completion: { [weak self] (reviewList) in
            guard let strongSelf = self else { return }
            if strongSelf.pageToLoad == 1 {
                strongSelf.arrReviews.removeAll()
            }
            strongSelf.arrReviews = strongSelf.arrReviews + reviewList
            strongSelf.tblViewReviews.reloadData()
            
            strongSelf.viewNoData.isHidden = strongSelf.arrReviews.count > 0 ? true : false
        })
    }
    
    //MARK: - IBACtions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
