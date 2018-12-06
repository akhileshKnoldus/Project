//
//  ManageStoreProductsViewC.swift
//  MyLoqta
//
//  Created by Kirti on 7/25/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SellerProfileViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewProducts: UITableView!
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var viewImageContainer: UIView!
    @IBOutlet weak var imgViewCover: UIImageView!
    @IBOutlet weak var btnEditProfile: UIButton!
    
    @IBOutlet weak var constraintEditButtonTrailing: NSLayoutConstraint!
    @IBOutlet weak var constraintEditButtonWidth: NSLayoutConstraint!
    
    //MARK: - Variables
    internal var viewModel: SellerProfileVModeling?
    var typeSelected: Int = 0
    var seller: SellerDetail?
    var arrayProducts = [Product]()
    var arrReviews = [Reviews]()
    var ratingCount: Int = 0
    var ratingStar: Double = 0.0
    var page = 1
    var pageReview = 1
    weak var delegate: ExploreDelegate?
    
    var isSelfProfile: Bool = true
    var sellerId: Int = 0
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.viewImageContainer.roundCorners(self.viewImageContainer.frame.size.width/2)
        self.imgViewProfile.roundCorners(self.imgViewProfile.frame.size.width/2)
        self.setupView()
        self.registerCell()
        self.recheckVM()
        self.getSellerProfile(sellerId: self.sellerId)
    }
    
    override func refreshApi() {
        self.getSellerProfile(sellerId: self.sellerId)
    }
    
    private func setupView() {
        if sellerId == Defaults[.sellerId] {
            self.isSelfProfile = true
        } else {
            self.isSelfProfile = false
        }
        if !isSelfProfile {
            self.btnEditProfile.isHidden = true
            self.constraintEditButtonWidth.constant = 0.0
            self.constraintEditButtonTrailing.constant = 0.0
        } else {
            guard let sellerID = Defaults[.sellerId] else { return }
            self.sellerId = sellerID
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerProfileVM()
        }
    }
    
    private func registerCell() {
        self.tblViewProducts.register(ProfileDetailCell.self)
        self.tblViewProducts.register(ManageStoreHeaderTableCell.self)
        self.tblViewProducts.register(ManageStoreProductsTableCell.self)
        self.tblViewProducts.register(ManageStoreReviewHeaderTableCell.self)
        self.tblViewProducts.register(ManageStoreReviewsTableCell.self)
        self.tblViewProducts.register(ManageStoreInfoTableCell.self)
        self.tblViewProducts.register(ManageStoreProductsHeaderCell.self)
        self.tblViewProducts.register(SellerProfileReviewMainTableCell.self)
    }
    
    private func setProfileData() {
        self.tblViewProducts.reloadData()
        if let profileUrl = seller?.profilePic, !profileUrl.isEmpty {
            self.imgViewProfile.contentMode = .scaleAspectFill
            self.imgViewProfile.setImage(urlStr: profileUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
        } else {
            self.imgViewProfile.contentMode = .center
            self.imgViewProfile.image = #imageLiteral(resourceName: "user_placeholder")
        }
        if let coverUrl = seller?.coverPic {
            self.imgViewCover.setImage(urlStr: coverUrl, placeHolderImage: nil)
        }
    }
    
    private func getProductsCount() -> Int {
        let count: Int = self.arrayProducts.count / 2
        return count
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
        self.tblViewProducts.reloadData()
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
        self.tblViewProducts.reloadData()
    }
    
    func updateGlobalLike(product: Product) {
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
        self.tblViewProducts.reloadData()
    }
    
    func updateFollowStatus(isFollow: Bool) {
        guard let sellr = self.seller else { return }
        sellr.isFollow = isFollow
        if var followersCount = sellr.followersCount {
            if isFollow {
                followersCount = followersCount + 1
                sellr.followersCount = followersCount
            } else {
                followersCount = followersCount - 1
                sellr.followersCount = followersCount
            }
        }
        self.seller = sellr
    }
    
    func loadMore() {
        if self.typeSelected == 0 {
           self.page += 1
           self.getSellerProductsList(page: self.page)
        } else if self.typeSelected == 2 {
            self.pageReview += 1
            self.getReviewsList(page: self.pageReview)
        }
    }
    
    //MARK: - API Methods
    
    private func getSellerProfile(sellerId: Int) {
        self.viewModel?.requestGetSellerProfile(sellerId: sellerId, completion: { [weak self] (seller) in
            guard let strongSelf = self else { return }
            strongSelf.seller = seller
            strongSelf.setProfileData()
            strongSelf.tblViewProducts.reloadData()
            strongSelf.getSellerProductsList(page: 1)
            strongSelf.getReviewsList(page: 1)
        })
    }
    
    private func getSellerProductsList(page: Int) {
        let param: [String: AnyObject] = ["sellerId": self.sellerId as AnyObject, "page": page as AnyObject]
        self.viewModel?.getSellerProductsList(param: param, completion: {[weak self] (arrProducts) in
            guard let strongSelf = self else { return }
            if strongSelf.page == 1 {
                strongSelf.arrayProducts.removeAll()
            }
            strongSelf.arrayProducts.append(contentsOf: arrProducts)
            strongSelf.tblViewProducts.reloadData()
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
        self.viewModel?.requestLikeProduct(param: param, completion: { [weak self] (success, isDeleted, message) in
            guard let strongSelf = self else {return}
            if success {
                strongSelf.updateLikeInDataSource(itemId: itemId, isLike: isLike)
            } else if isDeleted {
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: message, completeion_: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.removeProductFromDataSource(itemId: itemId)
                    }
                })
            }
        })
    }
    
    func requestFollowSeller() {
        guard let userId = self.seller?.userId, let followStatus = self.seller?.isFollow else { return }
        self.viewModel?.requestFollowSeller(followingId: userId, isFollow: !followStatus, completion: { [weak self]  (success)  in
            guard let strongSelf = self else { return }
            strongSelf.updateFollowStatus(isFollow: !followStatus)
            strongSelf.tblViewProducts.reloadData()
        })
    }
    
    func getReviewsList(page: Int) {
        self.viewModel?.requestGetSellerReviews(sellerId: self.sellerId, page: page, completion: { [weak self] (ratingCount, ratingStar, reviewList) in
            guard let strongSelf = self else { return }
            if strongSelf.page == 1 {
                strongSelf.arrReviews.removeAll()
            }
            strongSelf.ratingCount = ratingCount
            strongSelf.ratingStar = ratingStar
            strongSelf.arrReviews = strongSelf.arrReviews + reviewList
            strongSelf.tblViewProducts.reloadData()
        })
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapUploadBtn(_ sender: UIButton) {
        if self.sellerId > 0 {
            UserSession.sharedSession.shareLink(idValue: sellerId, isProduct: false, fromVC: self)
        }
    }
    
    @IBAction func tapEditBtn(_ sender: UIButton) {
        if let sellerEditVC = DIConfigurator.sharedInst().getSellerEditProfileVC() {
            sellerEditVC.seller = self.seller
            sellerEditVC.delegate = self
            sellerEditVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sellerEditVC, animated: true)
        }
    }
}

//MARK: - SellerEditProfileDelegates
extension SellerProfileViewC: SellerEditProfileDelegate {
    func reloadProfileView() {
        self.getSellerProfile(sellerId: self.sellerId)
    }
}

//MARK:- ScrollView Delegates
extension SellerProfileViewC {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMore()
        }
    }
}

