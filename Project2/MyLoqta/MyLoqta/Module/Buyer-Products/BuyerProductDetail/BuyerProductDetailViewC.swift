//
//  BuyerProductDetailViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 27/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import TPKeyboardAvoiding

let imageHeight = CGFloat(380)

class BuyerProductDetailViewC: BaseViewC {

    var viewModel: BuyerProductDetailVModeling?
    var product: Product?
    var productId: Int?
    var arrayRelatedItem = [Product]()
    var arraySellerItem = [Product]()
    var isAllQustLoaded = false
    var currentImageUrl: String = ""
    var shippingType: Int = 3
    var detailType = 1
    
    var shouldTrim = true
    weak var delegate: ExploreDelegate?
    
    @IBOutlet weak var btnAddToCard: AVButton!
    @IBOutlet weak var btnBuyNow: AVButton!
    //@IBOutlet weak var tblViewDetail: UITableView!
    @IBOutlet weak var tblViewDetail: TPKeyboardAvoidingTableView!
    
    //MARK:- View Life Cycle Methods
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
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Navigation
    private func setup() {
        self.recheckVM()
        self.registerNib()
        if self.product != nil {
            self.tblViewDetail.reloadData()
        }
        UserSession.sharedSession.removeGuestItems()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BuyerProductDetailVM()
        }
        self.registerNib()
        self.setupView()
        self.requestToProductDetail()
    }
    
    override func refreshApi() {
        self.requestToProductDetail()
    }
    
    private func registerNib() {
        self.tblViewDetail.register(DetailImageCell.self)
        self.tblViewDetail.register(DetailProductNameCell.self)
        self.tblViewDetail.register(DetailProductDesc.self)
        self.tblViewDetail.register(DetailProductShipping.self)
        self.tblViewDetail.register(DetailProductTypeCell.self)
        self.tblViewDetail.register(DetailProductQuestion.self)
        self.tblViewDetail.register(DetailProductAnswer.self)
        self.tblViewDetail.register(DetailProductSeller.self)
        self.tblViewDetail.register(DetailProductAskQuestion.self)
        self.tblViewDetail.register(OtherItemCell.self)
        self.tblViewDetail.register(DetailProductHaveQuestionCell.self)
    }
    
    private func setupView() {
        self.btnAddToCard.setTitle("Add to cart".localize(), for: .normal)
        self.btnAddToCard.setTitleColor(UIColor.appOrangeColor, for: .normal)
        self.btnAddToCard.makeLayer(color: UIColor.appOrangeColor, boarderWidth: Constant.borderWidth, round:Constant.btnCornerRadius)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 70))
        self.tblViewDetail.tableFooterView = footerView
    }
    
    // MARK: - Private Methods
    private func moveToCheckOutView() {
        if let checkOutVC = DIConfigurator.sharedInst().getCheckoutVC() {
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        }
    }
    
    func moveToMyCartViewC() {
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        if let myCartViewC = DIConfigurator.sharedInst().getMyCartVC() {
            let navC = UINavigationController(rootViewController: myCartViewC)
            myCartViewC.hidesBottomBarWhenPushed = true
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBAction functions
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @objc func tapOpenCart() {
        self.moveToMyCartViewC()
    }
    
    @objc func tapMoreOptions() {
    
        //Report as inappropriate
        let share = [Constant.keys.kTitle: "Share".localize(), Constant.keys.kColor: UIColor.actionBlackColor] as [String: Any]
        let reportProduct = [Constant.keys.kTitle: "Report".localize(), Constant.keys.kColor: UIColor.reportRedColor] as [String: Any]
        //let reportImage = [Constant.keys.kTitle: "Report this image".localize(), Constant.keys.kColor: UIColor.reportRedColor] as [String: Any]
        let actionItems = [share, reportProduct]
        Alert.showAlertSheetWithColor(title: nil, message: nil, actionItems: actionItems, showCancel: true) { (action) in
            switch action.title {
            case "Share".localize() :
                if let itemId = self.product?.itemId {
                    UserSession.sharedSession.shareLink(idValue: itemId, isProduct: true, fromVC: self)
                }
            case "Report".localize():
                //GuestCheck
                if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
                    emptyProfileVC.isGuest = true
                    self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
                    return
                }
                self.requestReportProduct(imageUrl: "")
            case "Report this image".localize():
                self.requestReportProduct(imageUrl: self.currentImageUrl)
            default:
                break
            }
        }
    }
    
    @IBAction func tapBuyNow(_ sender: Any) {
        self.requestToCheckCartSeller(isFromBuyNow: true)
        //self.requestToAddCartItem(isFromBuyNow: true)
    }
    
    @IBAction func tapAddToCard(_ sender: Any) {
        self.requestToCheckCartSeller(isFromBuyNow: false)
//        self.requestToAddCartItem(isFromBuyNow: false)
    }
    
    @objc func tapSeeMoreQuestion() {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        
        if let productId = self.product?.itemId {
            self.viewModel?.requestToQuestionAnswer(itemId: productId, completion: {[weak self] (array) in
                guard let strongSelf = self else { return }
                strongSelf.isAllQustLoaded = true
                strongSelf.product?.arrayQuestion = array
                strongSelf.tblViewDetail.reloadData()
                
            })
        }
    }
    
    //MARK: - Public Methods
    func removeProductFromDataSource(itemId: Int, isRelatedItems: Bool) {
        var index = 0
        if isRelatedItems {
            for product in self.arrayRelatedItem {
                if itemId == product.itemId {
                    self.arrayRelatedItem.remove(at: index)
                    break
                }
                index += 1
            }
        } else {
            for product in self.arraySellerItem {
                if itemId == product.itemId {
                    self.arraySellerItem.remove(at: index)
                    break
                }
                index += 1
            }
        }
        self.tblViewDetail.reloadData()
    }
    
    func updateProductLikeCount(isLike: Bool) {
        
//        if isDeleted {
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
        
        if var likeCount = self.product?.likeCount {
            product?.isLike = isLike
            if isLike {
                likeCount += 1
                product?.likeCount = likeCount
            } else {
                if likeCount > 0 {
                    likeCount -= 1
                    product?.likeCount = likeCount
                }
            }
            if let delegate = delegate, let prodct = self.product {
                delegate.didLikeProduct(product: prodct)
            }
            self.tblViewDetail.reloadData()
        }
    }
    
    func updateLikeInDataSource(itemId: Int, isLike: Bool, isRelatedItems: Bool) {
        var index = 0
        var arrayProducts = [Product]()
        if isRelatedItems {
            arrayProducts = self.arrayRelatedItem
        } else {
            arrayProducts = self.arraySellerItem
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
                if let delegate = delegate {
                    delegate.didLikeProduct(product: product)
                }
                if isRelatedItems {
                    self.arrayRelatedItem[index] = product
                } else {
                    self.arraySellerItem[index] = product
                }
                break
            }
            index += 1
        }
        self.tblViewDetail.reloadData()
    }
    
    func updateGlobalLike(product: Product){
        var index = 0
        for prodct in self.arrayRelatedItem {
            if product.itemId == prodct.itemId {
                prodct.isLike = product.isLike
                prodct.likeCount = product.likeCount
                self.arrayRelatedItem[index] = prodct
                break
            }
            index += 1
        }
        if product.itemId == self.product?.itemId {
            self.product?.isLike = product.isLike
            self.product?.likeCount = product.likeCount
        }
        self.tblViewDetail.reloadData()
    }
    
    func moveToAddressListViewC() {
        if let addressListVC = DIConfigurator.sharedInst().getAddressList() {
            addressListVC.isForCheckout = true
            addressListVC.isForBuyNow = true
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }
    }
    
    private func itemDeleted() {
        
        if let arrayVC = self.navigationController?.viewControllers {
            let count = arrayVC.count
            if count > 1, let viewC = arrayVC[(count - 2)] as? BaseViewC {
                viewC.refreshApi()
            }
        }
        Threads.performTaskAfterDealy(0.5) {
            self.navigationController?.popViewController(animated: true)
        }
        return
    }
    
    // MARK: - Api call
    func requestToProductDetail() {
        guard let productId = self.productId else { return }
        self.viewModel?.requestGetProductDetail(productId: productId, detailType: self.detailType, completion: { [weak self] (product, isDeleted) in
            guard let strongSelf = self else { return }
            if isDeleted {
                strongSelf.itemDeleted()
                return
            }
            strongSelf.product = product
            strongSelf.tblViewDetail.reloadData()
            strongSelf.getRelatedItem()
            strongSelf.getMoreFromSeller()
        })
    }
    
    func requestToAskQuestion(question: String) {
        if let itemId = self.productId {
            let param: [String: AnyObject] = ["question": question as AnyObject,
                                              "userId": UserSession.sharedSession.getUserId() as AnyObject,
                                              "itemId": itemId as AnyObject]
            self.viewModel?.requestToAskQuestion(param: param, completion: {[weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    //strongSelf.requestToProductDetail()
                }
            })
        }
    }
    
    func requestToCheckCartSeller(isFromBuyNow: Bool) {
        
        // Guest user checkout
        if !UserSession.sharedSession.isLoggedIn() {
            self.guestCheckOut(isFromBuyNow: isFromBuyNow)
            return
        }
        
        
        self.viewModel?.requestToCheckCartSeller(completion: { (sellerId) in
            if sellerId == self.product?.sellerId || sellerId == 0 {
                self.requestToAddCartItem(isFromBuyNow: isFromBuyNow)
            } else {
                Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Cart contains items from a different seller. Empty the cart and add this item?".localize(), actionTitle: "Yes".localize(), showCancel: true, action: { (action) in
                    self.requestToAddCartItem(isFromBuyNow: isFromBuyNow)
                })
            }
        })
    }
    
    func requestToAddCartItem(isFromBuyNow: Bool) {
        
        if let itemId = self.productId, let shipping = self.product?.shipping {
            let param: [String: AnyObject] = ["itemId" : itemId as AnyObject, "quantity": 1 as AnyObject, "shippingType": self.shippingType != 3 ? self.shippingType as AnyObject : shipping as AnyObject, "isBuyNow": isFromBuyNow ? 1 as AnyObject : 0 as AnyObject]
            
            self.viewModel?.requestToAddCartItem(param: param, completion: { (cartItemId) in
                if !isFromBuyNow {
                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Item is added to cart successfully".localize())
                    return
                } else {
                   self.moveToAddressListViewC()
                }
            })
        }
    }
    
    func getRelatedItem() {
        
        if let itemId = self.product?.itemId {
            self.viewModel?.getRelatedItem(itemId: itemId, completion: { [weak self]  (array) in
                guard let strongSelf = self else { return }
                strongSelf.arrayRelatedItem.removeAll()
                strongSelf.arrayRelatedItem.append(contentsOf: array)
                strongSelf.tblViewDetail.reloadData()
            })
        }
    }
    
    func getMoreFromSeller() {
        if let itemId = self.product?.itemId {
            self.viewModel?.getMoreFromSeller(itemId: itemId, completion: { [weak self]  (array) in
                guard let strongSelf = self else { return }
                strongSelf.arraySellerItem.removeAll()
                strongSelf.arraySellerItem.append(contentsOf: array)
                strongSelf.tblViewDetail.reloadData()
            })
        }
    }
    
    func requestLikeProduct(itemId: Int, isLike: Bool) {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.product?.isLike = !isLike
            self.tblViewDetail.reloadData()
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "isLike": isLike as AnyObject]
        self.viewModel?.requestLikeProduct(param: param, completion: {[weak self] (success, isDelete, message) in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.updateProductLikeCount(isLike: isLike)
            } else if isDelete {
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: message, completeion_: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.itemDeleted()
                    }
                })
            }
        })
    }
    
    func requestLikeProductInList(itemId: Int, isLike: Bool, isRelatedItem: Bool) {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
//            self.updateLikeInDataSource(itemId: itemId, isLike: !isLike, isRelatedItems: isRelatedItem)
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "isLike": isLike as AnyObject]
        self.viewModel?.requestLikeProduct(param: param, completion: {[weak self] (success, isDelete, message)  in
            guard let strongSelf = self else { return }
            if success {
                strongSelf.updateLikeInDataSource(itemId: itemId, isLike: isLike, isRelatedItems: isRelatedItem)
            } else if isDelete {
                Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: message, completeion_: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success {
                        strongSelf.removeProductFromDataSource(itemId: itemId, isRelatedItems: isRelatedItem)
                    }
                })
            }
        })
    }
    
    func requestReportProduct(imageUrl: String) {
        guard let itemId = self.product?.itemId else { return }
        let userId = Defaults[.userId]
        let param: [String: AnyObject] = ["userId": userId as AnyObject,"itemId": itemId as AnyObject, "imageUrl": imageUrl as AnyObject]
        self.viewModel?.requestReportProduct(param: param, completion: { (success) in
            print("Product Reported!")
        })
    }

    func getQuestionAnswerRow() -> Int {
        
        if let productDetail = self.product, let array = productDetail.arrayQuestion {
            if self.isAllQustLoaded {
                return array.count
            } else {
                if array.count >= 2 {
                    return 2
                } else {
                    return array.count
                }
            }
        }
        return 0
    }
    
    
    func guestCheckOut(isFromBuyNow: Bool){
        // Guest user case
        if let emptyVC = DIConfigurator.sharedInst().getEmptyProfileVC() {
            
            if let itemId = self.productId, let shipping = self.product?.shipping {
                let param: [String: AnyObject] = ["itemId" : itemId as AnyObject, "quantity": 1 as AnyObject, "shippingType": self.shippingType != 3 ? self.shippingType as AnyObject : shipping as AnyObject, "isBuyNow": isFromBuyNow ? 1 as AnyObject : 0 as AnyObject]
                UserSession.sharedSession.param = param
            }
            
            UserSession.sharedSession.guestCheckout = true
            UserSession.sharedSession.product = self.product
            self.navigationController?.pushViewController(emptyVC, animated: true)
        }
    }
    
    /*
    func getHeightOfQuestionCell(question: Question) -> CGFloat {
        
        var questionStr = ""
        var replyStr = ""
        var htQuestion = CGFloat(0)
        var htReply = CGFloat(0)
        
        if let questionstr = question.question {
            questionStr = questionstr
        }
        
        if let arrayReply = question.reply, arrayReply.count > 0 {
            let reply = arrayReply[0]
            if let replystr = reply.reply {
                replyStr = replystr
            }
        }
        
        let font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        
        if !questionStr.isEmpty {
            let constraintRect = CGSize(width: (Constant.screenWidth - 116), height: .greatestFiniteMagnitude)
            let boundingBox = questionStr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
            var ht = ceil(boundingBox.height)
            if ht < 27.0 {
                ht = 27
            }
            htQuestion = ht
        }
        
        if !replyStr.isEmpty {
            let constraintRect = CGSize(width: (Constant.screenWidth - 90), height: .greatestFiniteMagnitude)
            let boundingBox = questionStr.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
            var ht = ceil(boundingBox.height)
            if ht < 20.0 {
                ht = 20.0
            }
            htReply = ht
        }
        
        return (150 + htQuestion + htReply)
        
    }*/
    
    func getOtherProductsRow() -> Int {
        var count = 0
        if self.arrayRelatedItem.count > 0 {
            count += 1
        }
        if self.arraySellerItem.count > 0 {
            count += 1
        }
        return count
    }
}


