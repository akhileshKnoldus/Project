//
//  FilterViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class FilterViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var tblViewFilter: UITableView!
    
    //MARK: - Variables
    var viewModel: FilterVModeling?
    var arrayProductDesc = [[String: String]]()
    var filterValue = FilterValue()
    var updateFilter: ((_ filter: FilterValue)->Void)?
    var category: CategoryModel?
    var subCategory: SubCategoryModel?
    var originalSubCatId = 0
    var originalSubCategory = ""
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "cross"), target: self, action: #selector(tapCross))
        self.addRightButton(title: "Clear".localize(), titleColor: UIColor.appOrangeColor, font: nil, target: self, action: #selector(tapFilter))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.registerNib()
        self.originalSubCatId = self.filterValue.subCatId
        self.originalSubCategory = self.filterValue.subCategory
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = FilterVM()
        }
    }
    
    private func registerNib() {
        self.tblViewFilter.register(DetailProductTypeCell.self)
        self.tblViewFilter.register(PriceRangeCell.self)
        self.tblViewFilter.register(FilterCell.self)
//        self.setFooterView()
    }
    
    private func setFooterView() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 85))
        let button = AVButton(frame: CGRect(x: 15, y: 15, width: Constant.screenWidth - 32, height: 50))
        button.isButtonActive = true
        button.setTitle("Show results".localize(), for: .normal)
        button.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        button.setTitleColor(.white, for: .normal)
        button.conrnerRadius = CGFloat(8.0)
        button.addTarget(self, action: #selector(tapApplyFilter), for: .touchUpInside)
        view.addSubview(button)
        self.tblViewFilter.tableFooterView = view
    }
    
    // MARK: - IBAction functions
    @IBAction func tapApplyFilter(_ sender: UIButton) {
        if let refreshFilter = self.updateFilter {
            refreshFilter(self.filterValue)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapCross() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapFilter() {
        self.filterValue.condition = 0
        self.filterValue.sellerType = 0
        self.filterValue.shipping = 0
        self.filterValue.minPrice = 0
        self.filterValue.maxPrice = 0
        self.filterValue.subCatId = self.originalSubCatId
        self.filterValue.subCategory = self.originalSubCategory
        self.tblViewFilter.reloadData()
    }
    
    func updateCategory(category: CategoryModel, subCate: SubCategoryModel) {
        self.category = category
        self.subCategory = subCate
        if let name = subCate.name, let subCaId = subCate.id {
            self.filterValue.subCategory = name
            self.filterValue.subCatId = subCaId
        }
        self.tblViewFilter.reloadData()
    }
    
}

extension FilterViewC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 17
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 17))
        viewHeader.backgroundColor = UIColor.defaultBgColor
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return arrayProductDesc.count
        default: return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1: return 55
        default: return ( indexPath.row == 0 ? 160: 80)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0, 1: return self .getProductDescriptionCell(tableView: tableView, indexPath: indexPath)
        default:
            if indexPath.row == 0 {
                return self.getPriceRangeCell(tableView: tableView, indexPath: indexPath)
            } else {
                return self.getFilterCell(tableView: tableView, indexPath: indexPath)
            }
        }
    }
    
    
    
    func getProductDescriptionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductTypeCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.lblPlaceHolder.text = "Category".localize()
            cell.lblValue.text = "\(filterValue.category) > \(filterValue.subCategory)"
            cell.imgviewArrow.isHidden = false
        } else {
            cell.lblPlaceHolder.text = "Brand".localize()
            cell.lblValue.text = "Apple"
            cell.imgviewArrow.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, let subCategoryVC = DIConfigurator.sharedInst().getSubCategoryVC() {
            let category = CategoryModel()
            category.id = self.filterValue.cateId
            category.name = self.filterValue.category
            subCategoryVC.category = category
            
            self.navigationController?.pushViewController(subCategoryVC, animated: true)
        }
    }
    
    func getPriceRangeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: PriceRangeCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.filterDelegate = self
        cell.updateFilter(filer: self.filterValue)
        return cell
    }
    
    func getFilterCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(indexPath: indexPath, filer: self.filterValue)
        cell.filterDelegate = self
        return cell
    }
    
    func updateCodition(selIndex: Int)  {
        self.filterValue.condition = (selIndex + 1)
    }
    
    func updateSellerType(selIndex: Int)  {
        if selIndex == 0 {
            self.filterValue.sellerType = 2
        } else if selIndex == 1 {
            self.filterValue.sellerType = 1
        }
    }
    
    func updateShipping(selIndex: Int)  {
        switch selIndex {
        case 0: self.filterValue.shipping = 3
        case 1: self.filterValue.shipping = 5
        default: self.filterValue.shipping = 2
        }
    }
    
}

extension FilterViewC: FilterDelegate {
    
    func priceRange(minPirce: Int, maxPrice: Int) {
        self.filterValue.minPrice = minPirce
        self.filterValue.maxPrice = maxPrice
    }
    
    func selectFilterType(cell: UITableViewCell, selectedIndex: Int) {
        if let indexPath = self.tblViewFilter.indexPath(for: cell) {
            switch indexPath.row {
            case 1: self.updateCodition(selIndex: selectedIndex)
            case 2:self.updateSellerType(selIndex: selectedIndex)
            default:self.updateShipping(selIndex: selectedIndex)
            }
        }
    }
    
    
}
