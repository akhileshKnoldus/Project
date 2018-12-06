//
//  InsightViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class InsightViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var btnStatistic: UIButton!
    @IBOutlet weak var btnSearches: UIButton!
    @IBOutlet weak var btnSellings: UIButton!
    @IBOutlet weak var tblViewInsight: UITableView!
    
    //MARK: - Variables
    var viewModel: InsightVModeling?
    var filterDuration = FilterDuration.lastWeek.rawValue
    var arrayCategory = [[String: Any]]()
    var dataSource = [InsightStatsType]()
    var myStatistics: InsightStats?
    var searchData = [InsightSelling]()
    var sellingData = [InsightSelling]()
    var categoryId = 0
    var strCategoryName = ""
    let refresh = UIRefreshControl()

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
        self.initializeRefresh()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        self.btnStatistic.isSelected = true
        self.getCategoryList()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = InsightVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewInsight.delegate = self
        self.tblViewInsight.dataSource = self
        self.tblViewInsight.separatorStyle = .none
        self.tblViewInsight.allowsSelection = false
    }
    
    private func registerCell () {
        self.tblViewInsight.register(InsightHeaderCell.self)
        self.tblViewInsight.register(StatsRevenueCell.self)
        self.tblViewInsight.register(GraphTableCell.self)
        self.tblViewInsight.register(StatsListingCell.self)
        self.tblViewInsight.register(SellingProgressCell.self)
        self.tblViewInsight.register(NoDataCell.self)
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewInsight.refreshControl = refresh
    }
    
    private func addDefaultCategory() {
        let allCategory = ["id": 0,
                           "name": "All categories".localize()] as [String : Any]
        self.arrayCategory.insert(allCategory, at: 0)
    }
    
    private func loadData(isShowLoader: Bool) {
        if self.btnStatistic.isSelected {
            self.getInsightStatistics(isShowLoader: isShowLoader)
        } else if self.btnSearches.isSelected {
            self.getInsightSearchData(isShowLoader: isShowLoader)
        } else {
            self.getInsightSellingData(isShowLoader: isShowLoader)
        }
    }
    
    //MARK: - API Methods
    
    private func getCategoryList() {
        let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject]
        self.viewModel?.getCategoryList(param: param, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            strongSelf.arrayCategory = arrayCate
            strongSelf.addDefaultCategory()
            strongSelf.getInsightStatistics(isShowLoader: true)
        })
    }
    
    private func getInsightStatistics(isShowLoader: Bool) {
        let type = self.filterDuration
        self.viewModel?.requestGetMyStatistics(listType: type, isShowLoader: isShowLoader, completion: { [weak self] (myStats) in
            guard let strongSelf = self else { return }
            strongSelf.myStatistics = myStats
            if let dataSource = strongSelf.viewModel?.getDatasourceForStats() {
                strongSelf.dataSource = dataSource
            }
            strongSelf.tblViewInsight.reloadData()
        })
    }
    
    private func getInsightSearchData(isShowLoader: Bool) {
        let type = self.filterDuration
        let categoryID = self.categoryId
        self.viewModel?.requestGetInsightSearch(listType: type, categoryId: categoryID, isShowLoader: isShowLoader, completion: { [weak self] (arrSearchData) in
            guard let strongSelf = self else { return }
            strongSelf.searchData = arrSearchData
            if let dataSource = strongSelf.viewModel?.getDatasourceForSearchStats(insightSearchStats: arrSearchData) {
                strongSelf.dataSource = dataSource
            }
            strongSelf.tblViewInsight.reloadData()
        })
    }
    
    private func getInsightSellingData(isShowLoader: Bool) {
        let type = self.filterDuration
        let categoryID = self.categoryId
        self.viewModel?.requestGetInsightSelling(listType: type, categoryId: categoryID, isShowLoader: isShowLoader, completion: { [weak self] (arrSellingData) in
            guard let strongSelf = self else { return }
            strongSelf.sellingData = arrSellingData
            if let dataSource = strongSelf.viewModel?.getDatasourceForSellingStats(insightSearchStats: arrSellingData) {
                strongSelf.dataSource = dataSource
            }
            strongSelf.tblViewInsight.reloadData()
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.loadData(isShowLoader: false)
    }
    
    //MARK: - Public Methods
    func showCategoryPopup() {
        if self.arrayCategory.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select category".localize(), arrayList: self.arrayCategory as [[String : AnyObject]], keyValue: "name") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let catId = result["id"] as? Int, let catName = result["name"] as? String {
                    strongSelf.strCategoryName = catName
                    strongSelf.categoryId = catId
                    strongSelf.loadData(isShowLoader: false)
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    func showFilter() {
        let lastWeek = [Constant.keys.kTitle: "Last week".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let lastMonth = [Constant.keys.kTitle: "Last month".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let lastYear = [Constant.keys.kTitle: "Last year".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let actionItems = [lastWeek, lastMonth, lastYear]
        Alert.showAlertSheetWithColor(title: nil, message: nil, actionItems: actionItems, showCancel: true) { (action) in
            switch action.title {
            case "Last week".localize() :
                self.filterDuration = FilterDuration.lastWeek.rawValue
                self.loadData(isShowLoader: false)
            case "Last month".localize():
                self.filterDuration = FilterDuration.lastMonth.rawValue
                self.loadData(isShowLoader: false)
            case "Last year".localize():
                self.filterDuration = FilterDuration.lastYear.rawValue
                self.loadData(isShowLoader: false)
            default:
                break
            }
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapMyStatistic(_ sender: UIButton) {
        self.btnStatistic.isSelected = true
        self.btnSearches.isSelected = false
        self.btnSellings.isSelected = false
        self.filterDuration = FilterDuration.lastWeek.rawValue
        self.categoryId = 0
        self.strCategoryName = "All categories".localize()
        self.getInsightStatistics(isShowLoader: true)
    }
    
    @IBAction func tapSearches(_ sender: UIButton) {
        self.btnStatistic.isSelected = false
        self.btnSearches.isSelected = true
        self.btnSellings.isSelected = false
        self.filterDuration = FilterDuration.lastWeek.rawValue
        self.categoryId = 0
        self.strCategoryName = "All categories".localize()
        self.getInsightSearchData(isShowLoader: true)
    }
    
    @IBAction func tapSellings(_ sender: UIButton) {
        self.btnStatistic.isSelected = false
        self.btnSearches.isSelected = false
        self.btnSellings.isSelected = true
        self.filterDuration = FilterDuration.lastWeek.rawValue
        self.categoryId = 0
        self.strCategoryName = "All categories".localize()
        self.getInsightSellingData(isShowLoader: true)
    }
}
