//
//  ProductListViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ProductListViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    
    //MARK: - Variables
    var viewModel: ProductListVModeling?
    var arrayProducts = [Product]()
    var categoryName = ""
    var categoryId = 0
    var itemId: Int?
    var productsList: productsList?
    var page = 1
    weak var delegate: ExploreDelegate?
    let refresh = UIRefreshControl()
    
    //MARK: - LifeCycle Methods
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.setupCollectionView()
        self.initializeRefresh()
        self.txtFieldSearch.delegate = self
        self.txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "Search".localize(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.searchPlaceholderColor])
        self.viewSearch.roundCorners(Constant.btnCornerRadius)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getProductsList()
    }
    
    override func refreshApi() {
        self.getProductsList(isShowLoader: false)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ProductListVM()
        }
    }
    
    private func setupCollectionView() {
        self.collectionViewProducts.register(ExplorePopularCollectionCell.self)
        self.collectionViewProducts.register(ForYouCollectionCell.self)
        self.collectionViewProducts.dataSource = self
        self.collectionViewProducts.delegate = self
    }
    
    private func getProductsList(isShowLoader: Bool = true) {
        self.page = 1
        guard let productListType = self.productsList else { return }
        switch productListType {
        case .popular:
            self.getPopularProductsList(page: 1, isShowLoader: isShowLoader)
        case .relatedItems:
            self.getRelatedItem(page: 1, isShowLoader: isShowLoader)
        case .moreFromSeller:
            self.getMoreFromSeller(page: 1, isShowLoader: isShowLoader)
        case .forYouItems:
            self.getForYouItems(page: 1, isShowLoader: isShowLoader)
        }
    }
    
    func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionViewProducts.addSubview(refresh)
        //self.tblViewExplore.refreshControl = refresh
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.getProductsList(isShowLoader: false)
    }
    
    //MARK: - Public Methods
    
    func loadMoreData(isShowLoader: Bool = true) {
        guard let productListType = self.productsList else { return }
        self.page += 1
        switch productListType {
        case .popular:
            self.getPopularProductsList(page: self.page, isShowLoader: isShowLoader)
        case .relatedItems:
            self.getRelatedItem(page: self.page, isShowLoader: isShowLoader)
        case .moreFromSeller:
            self.getMoreFromSeller(page: self.page, isShowLoader: isShowLoader)
        case .forYouItems:
            self.getForYouItems(page: self.page, isShowLoader: isShowLoader)
        }
    }
    
    func removeProductFromDataSource(itemId: Int) {
        var index = 0
        for product in self.arrayProducts {
            if itemId == product.itemId {
                self.arrayProducts.remove(at: index)
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
        for product in self.arrayProducts {
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
                self.arrayProducts[index] = product
                break
            }
            index += 1
        }
        self.collectionViewProducts.reloadData()
    }
    
    func updateGlobalLike(product: Product){
        var index = 0
        for prodct in self.arrayProducts {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayProducts[index] = prodct
                break
            }
            index += 1
        }
        self.collectionViewProducts.reloadData()
    }
    
    func pushToSearchVC() {
        if let searchVC = DIConfigurator.sharedInst().getSearchVC() {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    //MARK: - API Methods
    private func getPopularProductsList(page: Int, isShowLoader: Bool) {
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"categoryId": self.categoryId as AnyObject, "page": page as AnyObject]
        self.viewModel?.getProductsList(param: param, isShowLoader: isShowLoader, completion: {[weak self] (arrProducts) in
            guard let strongSelf = self else { return }
            if page == 1 {
                strongSelf.arrayProducts.removeAll()
            }
            strongSelf.arrayProducts.append(contentsOf: arrProducts)
            strongSelf.collectionViewProducts.reloadData()
        })
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
            print("Liked Successful!")
        })
    }
    
    func getRelatedItem(page: Int, isShowLoader: Bool = true) {
        if let itemId = self.itemId {
            self.viewModel?.getRelatedItem(itemId: itemId, page: page, isShowLoader: isShowLoader, completion: { [weak self]  (arrProducts) in
                guard let strongSelf = self else { return }
                if page == 1 {
                    strongSelf.arrayProducts.removeAll()
                }
                strongSelf.arrayProducts.append(contentsOf: arrProducts)
                strongSelf.collectionViewProducts.reloadData()
            })
        }
    }
    
    func getMoreFromSeller(page: Int, isShowLoader: Bool = true) {
        if let itemId = self.itemId {
            self.viewModel?.getMoreFromSeller(itemId: itemId, page: page, isShowLoader: isShowLoader, completion: { [weak self]  (arrProducts) in
                guard let strongSelf = self else { return }
                if page == 1 {
                    strongSelf.arrayProducts.removeAll()
                }
                strongSelf.arrayProducts.append(contentsOf: arrProducts)
                strongSelf.collectionViewProducts.reloadData()
            })
        }
    }
    
    func getForYouItems(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.requestGetForYouItems(page: page, isShowLoader: isShowLoader, completion: { [weak self]  (arrProducts) in
            guard let strongSelf = self else { return }
            if page == 1 {
                strongSelf.arrayProducts.removeAll()
            }
            strongSelf.arrayProducts.append(contentsOf: arrProducts)
            strongSelf.collectionViewProducts.reloadData()
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOpenCart(_ sender: UIButton) {
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
}

//MARK:- UITextField Delegates
extension ProductListViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pushToSearchVC()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
