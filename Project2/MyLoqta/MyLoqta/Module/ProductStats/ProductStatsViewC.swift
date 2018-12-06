//
//  ProductStatsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ProductStatsViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var tblViewStats: UITableView!
    
    
    //MARK: - Varibales
    var viewModel: ProductStatsVModeling?
    var filterDuration = FilterDuration.lastWeek.rawValue
    var dataSource = [InsightStatsType]()
    var productStats: ProductStats?
    var itemId = 0
    var itemName: String?
    var itemImage: String?

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
        self.getProductStatistics()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ProductStatsVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewStats.delegate = self
        self.tblViewStats.dataSource = self
        self.tblViewStats.separatorStyle = .none
        self.tblViewStats.allowsSelection = false
    }
    
    private func registerCell () {
        self.tblViewStats.register(StatsHeaderCell.self)
        self.tblViewStats.register(StatsRevenueCell.self)
        self.tblViewStats.register(GraphTableCell.self)
        self.tblViewStats.register(StatsListingCell.self)
    }
    
    //MARK: - APIMethods
    private func getProductStatistics() {
        let type = self.filterDuration
        self.viewModel?.requestGetProductStatistics(itemId: self.itemId, listType: type, completion: { [weak self] (productStat) in
            guard let strongSelf = self else { return }
            strongSelf.productStats = productStat
            if let dataSource = strongSelf.viewModel?.getDatasourceForProductStats() {
                strongSelf.dataSource = dataSource
            }
            strongSelf.tblViewStats.reloadData()
        })
    }
    
    //MARK: - Public Methods
    func showFilter() {
        let lastWeek = [Constant.keys.kTitle: "Last week".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let lastMonth = [Constant.keys.kTitle: "Last month".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let lastYear = [Constant.keys.kTitle: "Last year".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let actionItems = [lastWeek, lastMonth, lastYear]
        Alert.showAlertSheetWithColor(title: nil, message: nil, actionItems: actionItems, showCancel: true) { (action) in
            switch action.title {
            case "Last week".localize() :
                self.filterDuration = FilterDuration.lastWeek.rawValue
                self.getProductStatistics()
            case "Last month".localize():
                self.filterDuration = FilterDuration.lastMonth.rawValue
                self.getProductStatistics()
            case "Last year".localize():
                self.filterDuration = FilterDuration.lastYear.rawValue
                self.getProductStatistics()
            default:
                break
            }
        }
    }

    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
