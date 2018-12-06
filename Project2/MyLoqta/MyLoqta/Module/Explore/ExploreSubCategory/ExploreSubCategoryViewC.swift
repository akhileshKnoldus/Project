//
//  ExploreSubCategoryViewC.swift
//  MyLoqta
//
//  Created by Kirti on 7/24/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol ExploreDelegate: class {
    func didLikeProduct(product: Product)
}

class ExploreSubCategoryViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var lblItemsFound: UILabel!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    @IBOutlet weak var viewHeader: AVView!
    
    var filterValue = FilterValue()
    
    //MARK: - Variables
    weak var delegate: ExploreDelegate?
    var viewModel: ExploreSubCategoryVModeling?
    var arraySubCategoryProducts = [Product]()
    var searchBarText = ""
    var category: CategoryModel?
    var subCategory: SubCategoryModel?
    var page = 1
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.setupCollectionView()
        self.setupDataOnView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getSubCategoryProductsList(page: 1)
        
        if let cat = self.category, let catName = cat.name, let catId = cat.id {
            self.filterValue.cateId = catId
            self.filterValue.category = catName
        }
        
        if let sbCat = self.subCategory, let subCatName = sbCat.name, let subCatId = sbCat.id {
            self.filterValue.subCatId = subCatId
            self.filterValue.subCategory = subCatName
        }
    }
    
    override func refreshApi() {
        self.getSubCategoryProductsList(page: 1)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ExploreSubCategoryVM()
        }
    }
    
    private func setupCollectionView() {
        self.collectionViewProducts.register(ExplorePopularCollectionCell.self)
        self.collectionViewProducts.dataSource = self
        self.collectionViewProducts.delegate = self
    }
    
    private func setupDataOnView() {
        Threads.performTaskAfterDealy(0.1) {
            if let subCatgry = self.subCategory, let startColor = subCatgry.startGradient, let endColor = subCatgry.endGradient {
                self.viewHeader.drawGradientWith(startColor: startColor, endColor: endColor)
            }
        }
        if let sbCategory = self.subCategory, let sbCatgeoryName = sbCategory.name {
            searchBarText = sbCatgeoryName
        }
        
        if let sbCategory = self.subCategory, let itemCount = sbCategory.productCount {
            self.lblItemsFound.text = itemCount > 1 ? "\(itemCount) " + "items found".localize() : "\(itemCount) " + "item found".localize()
        } else {
            self.lblItemsFound.isHidden = true
        }
        self.txtFieldSearch.delegate = self
        self.txtFieldSearch.attributedPlaceholder = NSAttributedString(string: searchBarText, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.viewSearch.roundCorners(Constant.btnCornerRadius)
    }
    
    func loadMore() {
        self.page += 1
        self.getSubCategoryProductsList(page: self.page)
    }
    
    func removeProductFromDataSource(itemId: Int) {
        var index = 0
        for product in self.arraySubCategoryProducts {
            if itemId == product.itemId {
                self.arraySubCategoryProducts.remove(at: index)
                break
            }
            index += 1
        }
        self.collectionViewProducts.reloadData()
    }
    
    func updateLikeInDataSource(itemId: Int, isLike: Bool) {
//        if isDelete {
//            if let arrayVC = self.navigationController?.viewControllers {
//                let count = arrayVC.count
//                if count > 1, let viewC = arrayVC[(count - 2)] as? BaseViewC {
//                    viewC.refreshApi()
//                }
//            }
//            Threads.performTaskAfterDealy(0.5) {
//                self.navigationController?.popViewController(animated: true)
//            }
//            return
//        }
        var index = 0
        for product in self.arraySubCategoryProducts {
            if itemId == product.itemId {
                product.isLike = isLike
                if var likeCount = product.likeCount {
                    if isLike {
                        likeCount += 1
                        product.likeCount = likeCount
                    } else {
                        if likeCount > 0 {
                            likeCount -= 1
                            product.likeCount = likeCount
                        }
                    }
                }
                if let delegate = self.delegate {
                    delegate.didLikeProduct(product: product)
                }
                self.arraySubCategoryProducts[index] = product
                break
            }
            index += 1
        }
        self.collectionViewProducts.reloadData()
    }
    
    func updateGlobalLike(product: Product){
        var index = 0
        for prodct in self.arraySubCategoryProducts {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arraySubCategoryProducts[index] = prodct
                break
            }
            index += 1
        }
        self.collectionViewProducts.reloadData()
    }
    
    //MARK: - API Methods
    private func getSubCategoryProductsList(page: Int, isShowLoader: Bool = true) {
        
        self.viewModel?.getSubCategoryProducts(param: self.getParam(), isShowLoader: isShowLoader, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            if strongSelf.page == 1 {
                strongSelf.arraySubCategoryProducts.removeAll()
            }
            strongSelf.arraySubCategoryProducts.append(contentsOf: arrayCate)
            strongSelf.collectionViewProducts.reloadData()
        })
    }
    
    func getParam() -> [String: AnyObject] {
        guard let sbCategory = self.subCategory else { return [:]}
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,
                                          "categoryId": sbCategory.id as AnyObject,
                                          "page": page as AnyObject,
                                          "condition": filterValue.condition as AnyObject,
                                          "shipping": filterValue.shipping as AnyObject,
                                          "minPrice": filterValue.minPrice as AnyObject,
                                          "maxPrice": filterValue.maxPrice as AnyObject,
                                          "sellerType": filterValue.sellerType as AnyObject,
                                          "filterKey": filterValue.filterKey as AnyObject]
        return param
        
    }
    
    private func updateFilterValue(updatedFilter: FilterValue) {
        self.filterValue.maxPrice = updatedFilter.maxPrice
        self.filterValue.minPrice = updatedFilter.minPrice
        self.filterValue.condition = updatedFilter.condition
        self.filterValue.sellerType = updatedFilter.sellerType
        self.filterValue.shipping = updatedFilter.shipping
        self.page = 1
        self.getSubCategoryProductsList(page: self.page)
        
    }
    
    func requestLikeProduct(itemId: Int, isLike: Bool) {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
//            self.updateLikeInDataSource(itemId: itemId, isLike: !isLike)
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "isLike": isLike as AnyObject]
        self.viewModel?.requestLikeProduct(param: param, completion: { [weak self] (success, isDelete, message) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.updateLikeInDataSource(itemId: itemId, isLike: isLike)
            } else if isDelete {
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: message, completeion_: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.removeProductFromDataSource(itemId: itemId)
                    }
                })
            }
        })
    }
    
    func moveToMyCartViewC() {
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        if let myCartVC = DIConfigurator.sharedInst().getMyCartVC() {
            let navC = UINavigationController(rootViewController: myCartVC)
            myCartVC.hidesBottomBarWhenPushed = true
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    func pushToSearchVC() {
        if let searchVC = DIConfigurator.sharedInst().getSearchVC() {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOpenCartBtn(_ sender: UIButton) {
        self.moveToMyCartViewC()
    }
    
    @IBAction func tapBtnSort(_ sender: UIButton) {
        Alert.showAlertWithActionWithCancel(title: nil, message: nil, style: .actionSheet, actionTitles: ["Price low to high".localize(), "Price high to low".localize(), "Clear sorting".localize()], showCancel: true, deleteTitle: nil) { action in
            if let title = action.title {
                switch title {
                case "Price low to high".localize() : self.filterValue.filterKey = 1
                case "Price high to low".localize() : self.filterValue.filterKey = 2
                default: self.filterValue.filterKey = 0
                }
            }
            self.page = 1
            self.getSubCategoryProductsList(page: self.page)
        }
    }
    
    @IBAction func tapBtnFilter(_ sender: UIButton) {
        if let filterVC = DIConfigurator.sharedInst().getFilterVC() {
            filterVC.filterValue = self.filterValue
            self.navigationController?.pushViewController(filterVC, animated: true)
            filterVC.updateFilter = { [weak self] filter in
                guard let strongSelf = self else { return }
                strongSelf.updateFilterValue(updatedFilter: filter)
            }
        }
    }
}

//MARK:- UITextField Delegates
extension ExploreSubCategoryViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pushToSearchVC()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
