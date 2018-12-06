//
//  HomeViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class HomeViewC: BaseViewC {

    //MARK:- IBOutlets
    @IBOutlet weak var tblViewProductList: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    
    //MARK:- Variables
    var viewModel: HomeVModeling?
    var arrayOfFirstFeed = [Product]()
    var arrayOfForYou = [Product]()
    var categoryInfo: CategoryModel?
    var arrayOfSecondFeed = [Product]()
    var arrayOfLastFeed = [Product]()
    var arrayDataSource = [[HomeFeedType]]()
    var pageToLoad = 1
    
    var cellHeights: [IndexPath : CGFloat] = [:]
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
    private func setUp(){
        self.recheckVM()
        self.registerCell()
        self.initializeRefresh()
        self.requestToCallHomeFeedApi(page: self.pageToLoad)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = HomeVM()
        }
    }
    
    override func refreshApi() {
        self.pageToLoad = 1
        self.requestToCallHomeFeedApi(page: self.pageToLoad)
    }
    
    private func registerCell() {
        self.tblViewProductList.register(ProductCell.self)
        self.tblViewProductList.register(SponsoredCell.self)
        self.tblViewProductList.register(CategoryTableCell.self)
        self.tblViewProductList.register(ForYouTableCell.self)
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewProductList.refreshControl = refresh
    }
    
    private func requestToCallHomeFeedApi(page: Int, isShowLoader: Bool = true) {
        self.viewModel?.getHomeFeedDetails(page: page, isShowLoader: isShowLoader, completion: {[weak self] (homeFeedData) in
            guard let strongSelf = self else { return }
            if page == 1 {
                strongSelf.arrayDataSource = []
            }
            if let arrFirstFeed = homeFeedData.feedFirst {
                if page == 1 {
                    strongSelf.arrayOfFirstFeed.removeAll()
                }
                strongSelf.arrayOfFirstFeed = strongSelf.arrayOfFirstFeed + arrFirstFeed
            }
            if let arrForYou = homeFeedData.forYou, page == 1 {
                strongSelf.arrayOfForYou = arrForYou
            }
            if let arrSecondFeed = homeFeedData.feedSecond {
                if page == 1 {
                    strongSelf.arrayOfSecondFeed.removeAll()
                }
                strongSelf.arrayOfSecondFeed = strongSelf.arrayOfSecondFeed + arrSecondFeed
            }
            if let category = homeFeedData.category, page == 1 {
                strongSelf.categoryInfo = category
            }
            if let arrLastFeed = homeFeedData.feedLast {
                if page == 1 {
                    strongSelf.arrayOfLastFeed.removeAll()
                }
                strongSelf.arrayOfLastFeed = strongSelf.arrayOfLastFeed + arrLastFeed
                print(arrLastFeed.count)
                print(strongSelf.arrayOfLastFeed)
                print(strongSelf.arrayOfLastFeed.count)
            }
            if let arrDataSource = strongSelf.viewModel?.getDatasourceForHomeFeed(homeFeedData: homeFeedData, page: page, previousDataSource: strongSelf.arrayDataSource)  {
                print(arrDataSource)
                strongSelf.arrayDataSource = arrDataSource
            }
            strongSelf.tblViewProductList.reloadData()
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.pageToLoad = 1
        self.requestToCallHomeFeedApi(page: self.pageToLoad, isShowLoader: false)
    }
    
    func loadMoreData() {
        self.pageToLoad += 1
        self.requestToCallHomeFeedApi(page: self.pageToLoad)
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
    
    func moveToExploreCategoryVC(category: CategoryModel) {
        self.view.endEditing(true)
        if let exploreCategoreViewC = DIConfigurator.sharedInst().getExploreCategoryVC() {
            exploreCategoreViewC.category = category
//            exploreCategoreViewC.delegate = self
            self.navigationController?.pushViewController(exploreCategoreViewC, animated: true)
        }
    }
    
    func requestLikeProduct(itemId: Int, isLike: Bool, feedType: HomeFeedsCell) {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
//            self.updateLikeInDataSource(itemId: itemId, isLike: !isLike, feedType: feedType)
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "isLike": isLike as AnyObject]
        self.viewModel?.requestLikeProduct(param: param, completion: {[weak self] (success, isDelete, message) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.updateLikeInDataSource(itemId: itemId, isLike: isLike, feedType: feedType)
            } else if isDelete {
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: message, completeion_: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.refreshApi()
                    }
                })
            }
        })
    }
    
    func updateLikeInDataSource(itemId: Int, isLike: Bool, feedType: HomeFeedsCell) {
        var index = 0
        var arrayProducts = [Product]()
        switch feedType {
        case .firstFeedCell:
            arrayProducts = self.arrayOfFirstFeed
        case .secondFeedCell:
            arrayProducts = self.arrayOfSecondFeed
        case .lastFeedCell:
            arrayProducts = self.arrayOfLastFeed
        case .forYouCell:
            arrayProducts = self.arrayOfForYou
        default:
            return
        }
        for product in arrayProducts {
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
                arrayProducts[index] = product
                break
            }
            index += 1
        }
        switch feedType {
        case .firstFeedCell:
            self.arrayOfFirstFeed = arrayProducts
        case .secondFeedCell:
            self.arrayOfSecondFeed = arrayProducts
        case .lastFeedCell:
            self.arrayOfLastFeed = arrayProducts
        case .forYouCell:
            self.arrayOfForYou = arrayProducts
        default:
            return
        }
        self.tblViewProductList.reloadData()
    }
    
    func updateGlobalLike(product: Product) {
        var index = 0
        
        //ForYouFeed
        for prodct in self.arrayOfForYou {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayOfForYou[index] = prodct
                self.tblViewProductList.reloadData()
                break
            }
            index += 1
        }
        
        index = 0
        //FirstFeed
        for prodct in self.arrayOfFirstFeed {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayOfFirstFeed[index] = prodct
                self.tblViewProductList.reloadData()
                return
            }
            index += 1
        }
        
        index = 0
        //SecondFeed
        for prodct in self.arrayOfSecondFeed {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayOfSecondFeed[index] = prodct
                self.tblViewProductList.reloadData()
                return
            }
            index += 1
        }
        
        index = 0
        //LastFeed
        for prodct in self.arrayOfLastFeed {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayOfLastFeed[index] = prodct
                self.tblViewProductList.reloadData()
                return
            }
            index += 1
        }
    }
    
    func moveToBuyerProductDetailView(productId: Int) {
        if let buyerProductDetailVC = DIConfigurator.sharedInst().getBuyerProducDetail() {
            buyerProductDetailVC.productId = productId
            buyerProductDetailVC.delegate = self
            self.navigationController?.pushViewController(buyerProductDetailVC, animated: true)
        }
    }
    
    func moveToSellerProfile(sellerId: Int) {
        if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC() {
            //sellerProfileVC.isSelfProfile = false
            sellerProfileVC.sellerId = sellerId
            sellerProfileVC.delegate = self
            sellerProfileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sellerProfileVC, animated: true)
        }
    }
    
    func performActionOnTappingMoreOptions(product: Product) {
        let share = [Constant.keys.kTitle: "Share".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let reportProduct = [Constant.keys.kTitle: "Report".localize(), Constant.keys.kColor: UIColor.reportRedColor] as [String: Any]
//        let reportImage = [Constant.keys.kTitle: "Report this image".localize(), Constant.keys.kColor: UIColor.reportRedColor] as [String: Any]
        let actionItems = [share, reportProduct]
        Alert.showAlertSheetWithColor(title: nil, message: nil, actionItems: actionItems, showCancel: true) { (action) in
            switch action.title {
            case "Share".localize() :
                if let itemId = product.itemId {
                    UserSession.sharedSession.shareLink(idValue: itemId, isProduct: true, fromVC: self)
                }
            case "Report".localize():
                //GuestCheck
                if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
                    emptyProfileVC.isGuest = true
                    self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
                    return
                }
                self.requestReportProduct(imageUrl: "", product: product)
            case "Report this image".localize():
                if let imgUrl = product.imageFirstUrl {
                self.requestReportProduct(imageUrl: imgUrl, product: product)
                }
            default:
                break
            }
        }
    }
    
    func requestReportProduct(imageUrl: String, product: Product) {
        guard let itemId = product.itemId else { return }
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "imageUrl": imageUrl as AnyObject]
        self.viewModel?.requestReportProduct(param: param, completion: { (success) in
            print("Product Reported!")
        })
    }
    
    func pushToSearchVC() {
        if let searchVC = DIConfigurator.sharedInst().getSearchVC() {
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapOpenCart(_ sender: UIButton) {
        self.moveToMyCartViewC()
    }
}

//MARK:- UITextField Delegates
extension HomeViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pushToSearchVC()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
