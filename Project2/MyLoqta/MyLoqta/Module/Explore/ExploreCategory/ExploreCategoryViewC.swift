//
//  ExploreCategoryViewC.swift
//  MyLoqta
//
//  Created by Kirti on 7/21/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class ExploreCategoryViewC: BaseViewC {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblNumOfItems: UILabel!
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewHeader: AVView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var viewFollow: AVView!
    @IBOutlet weak var imgViewFollow: UIImageView!
    @IBOutlet weak var lblFollow: UILabel!

    //MARK: - Variables
    var viewModel: ExploreCategoryVModeling?
    var arraySubCategory = [SubCategoryModel]()
    var arrayPopularProducts = [Product]()
    var category: CategoryModel?
    weak var delegate: ExploreDelegate?
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
        self.setDataOnView()
        self.setupView()
        self.setupFollowView()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.getSubCategoryList()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ExploreCategoryVM()
        }
    }
    
    override func refreshApi() {
        self.getSubCategoryList(isShowLoader: false)
    }
    
    private func setupFollowView() {
        self.viewFollow.layer.borderWidth = 1.0
        self.viewFollow.layer.borderColor = UIColor.white.cgColor
        if let catgry = self.category, let followStatus = catgry.isCategoryFollow {
            self.updateFollowStatus(isFollow: followStatus)
        }
    }
    
    private func registerCell() {
        self.tblView.register(ExploreSubCategoryTableCell.self)
        self.tblView.register(ExplorePopularTableCell.self)
        self.tblView.register(FeaturedShopTableCell.self)
    }
    
    private func setupView() {
        Threads.performTaskAfterDealy(0.05) {
            if let catgry = self.category, let startColor = catgry.startGradient, let endColor = catgry.endGradient {
                self.viewHeader.drawGradientWith(startColor: startColor, endColor: endColor)
            }
        }
        self.txtFieldSearch.delegate = self
        self.txtFieldSearch.attributedPlaceholder = NSAttributedString(string: "Search".localize(), attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        self.viewSearch.roundCorners(Constant.btnCornerRadius)
    }
    
    private func setDataOnView() {
        guard let catgry = self.category else { return }
        self.lblCategory.text = catgry.name
        if let itemCount = catgry.productCount {
            self.lblNumOfItems.text = itemCount > 1 ? "\(itemCount) " + "items" : "\(itemCount) " + "item"
        } else {
            self.lblNumOfItems.isHidden = true
        }
        if let isCatFollow = catgry.isCategoryFollow {
            self.updateFollowStatus(isFollow: isCatFollow)
        }
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
        self.tblView.reloadData()
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
                if let delegate = self.delegate {
                    delegate.didLikeProduct(product: product)
                }
                self.arrayPopularProducts[index] = product
                break
            }
            index += 1
        }
        self.tblView.reloadData()
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
        self.tblView.reloadData()
    }
    
    func updateFollowStatus(isFollow: Bool) {
        if isFollow {
            self.lblFollow.text = "Following".localize()
            self.imgViewFollow.image = #imageLiteral(resourceName: "tick")
        } else {
            self.lblFollow.text = "Follow".localize()
            self.imgViewFollow.image = #imageLiteral(resourceName: "plus_white")
        }
    }
    
    func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblView.addSubview(refresh)
        //self.tblViewExplore.refreshControl = refresh
    }
    
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.tblView.reloadData()
        self.getSubCategoryList(isShowLoader: false)
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
    
    private func getSubCategoryList(isShowLoader: Bool = true) {
        guard let catgry = self.category else { return }
        let param: [String: AnyObject] = ["categoryId": catgry.id as AnyObject, "key": 1 as AnyObject, "page": 1 as AnyObject]
        self.viewModel?.getSubCategory(param: param, isShowLoader: isShowLoader, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            strongSelf.arraySubCategory = arrayCate
            strongSelf.tblView.reloadData()
            strongSelf.getPopularProductsList(isShowLoader: isShowLoader)
        })
    }
    
    private func getPopularProductsList(isShowLoader: Bool = true) {
        let userId = Defaults[.userId]
        guard let catgry = self.category else { return }
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"categoryId": catgry.id as AnyObject, "page": 0 as AnyObject]
        self.viewModel?.getPopularProducts(param: param, isShowLoader: isShowLoader, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            strongSelf.arrayPopularProducts = arrayCate
            strongSelf.tblView.reloadData()
        })
    }
    
    func requestFollowCategory() {
        guard let categoryId = self.category?.id else { return }
        guard let isFollow = self.category?.isCategoryFollow else { return }
        self.viewModel?.requestFollowCategory(categoryId: categoryId, isFollow: !isFollow, completion: { [weak self]  (success)  in
            guard let strongSelf = self else { return }
            strongSelf.category?.isCategoryFollow = !isFollow
            strongSelf.updateFollowStatus(isFollow: !isFollow)
        })
    }
    
    func moveToExploreSubCategoryView(subCategory: SubCategoryModel) {
        if let exploreSubCategoryViewC = DIConfigurator.sharedInst().getExploreSubCategoryVC() {
            exploreSubCategoryViewC.category = self.category
            exploreSubCategoryViewC.subCategory = subCategory
            exploreSubCategoryViewC.delegate = self
            self.navigationController?.pushViewController(exploreSubCategoryViewC, animated: true)
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
    
    @IBAction func tapBtnFollow(_ sender: UIButton) {
        self.requestFollowCategory()
    }
}

//MARK:- UITextField Delegates
extension ExploreCategoryViewC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.pushToSearchVC()
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
