//
//  ExploreMainViewC.swift
//  MyLoqta
//
//  Created by Kirti on 7/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ExploreMainViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var tblViewExplore: UITableView!
    
    //MARK: - Variables
    var viewModel: ExploreMainVModeling?
    var arrayCategory = [CategoryModel]()
    var arrayPopularProducts = [Product]()
    
    let refresh = UIRefreshControl()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.registerCell()
        self.initializeRefresh()
        self.txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "Search".localize(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.searchPlaceholderColor])
        self.viewSearch.roundCorners(Constant.btnCornerRadius)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getCategoryList()
    }
    
    override func refreshApi() {
        self.getCategoryList(isShowLoader: false)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ExploreMainVM()
        }
    }
    
    private func registerCell () {
        self.tblViewExplore.register(ExploreCategoriesTableCell.self)
        self.tblViewExplore.register(ExplorePopularTableCell.self)
        self.tblViewExplore.register(FeaturedShopTableCell.self)
    }
    
    func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewExplore.addSubview(refresh)
        //self.tblViewExplore.refreshControl = refresh
    }
    
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.tblViewExplore.reloadData()
        self.getCategoryList(isShowLoader: false)
    }
    
    func updateLikeInDataSource(itemId: Int, isLike: Bool) {
        var index = 0
        for product in self.arrayPopularProducts {
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
                self.arrayPopularProducts[index] = product
                break
            }
            index += 1
        }
        self.tblViewExplore.reloadData()
    }
    
    func updateGlobalLike(product: Product){
        var index = 0
        for prodct in self.arrayPopularProducts {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayPopularProducts[index] = prodct
                break
            }
            index += 1
        }
        self.tblViewExplore.reloadData()
    }
    
    //MARK: - API Methods
    private func getCategoryList(isShowLoader: Bool = true) {
        let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject]
        self.viewModel?.getCategoryList(param: param, isShowLoader: isShowLoader, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            strongSelf.arrayCategory = arrayCate
            strongSelf.tblViewExplore.reloadData()
            strongSelf.getPopularProductsList(isShowLoader: isShowLoader)
        })
    }
    
    private func getPopularProductsList(isShowLoader: Bool = true) {
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"categoryId": 0 as AnyObject, "page": 0 as AnyObject]
        self.viewModel?.getPopularProducts(param: param, isShowLoader: isShowLoader, completion: {[weak self] (arrProducts) in
            guard let strongSelf = self else { return }
            strongSelf.arrayPopularProducts = arrProducts
            strongSelf.tblViewExplore.reloadData()
        })
    }
    
    func removeProductFromDataSource(itemId: Int) {
        var index = 0
        for product in self.arrayPopularProducts {
            if itemId == product.itemId {
                self.arrayPopularProducts.remove(at: index)
                break
            }
            index += 1
        }
        self.tblViewExplore.reloadData()
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
        self.viewModel?.requestLikeProduct(param: param, completion: {[weak self] (success, isDelete, message) in
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
    
    func moveToExploreCategoryVC(category: CategoryModel) {
        self.view.endEditing(true)
        if let exploreCategoreViewC = DIConfigurator.sharedInst().getExploreCategoryVC() {
            exploreCategoreViewC.category = category
            exploreCategoreViewC.delegate = self
            self.navigationController?.pushViewController(exploreCategoreViewC, animated: true)
        }
    }
    
    func moveToManageStoreProductsVC() {
        //if let manageStoreProductsViewC = DIConfigurator.sharedInst().getManageStoreProductsVC() {
            //self.navigationController?.pushViewController(manageStoreProductsViewC, animated: true)
        //}
    }
    
    func moveToProductDetail(product: Product) {
        self.view.endEditing(true)
        if let detailVC = DIConfigurator.sharedInst().getBuyerProducDetail(), let productId = product.itemId {
            detailVC.productId = productId
            detailVC.delegate = self
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
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
    
    //MARK:- IBAction Methods
    @IBAction func tapOpenCartBtn(_ sender: UIButton) {
        self.moveToMyCartViewC()
    }
    
    func pushToSearchVC() {
        if let searchVC = DIConfigurator.sharedInst().getSearchVC() {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
}

//MARK:- UITextField Delegates
extension ExploreMainViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pushToSearchVC()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK:- OpenProductDetail Delegates
extension ExploreMainViewC: OpenProductDetailDelegates {
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?) {
        //self.moveToManageStoreProductsVC()
        let product = self.arrayPopularProducts[indexPath.item]
        self.moveToProductDetail(product: product)
    }
}
