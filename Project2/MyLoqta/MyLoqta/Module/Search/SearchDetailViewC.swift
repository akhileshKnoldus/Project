//
//  SearchDetailViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 14/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SearchDetailViewC: BaseViewC {
    
    @IBOutlet weak var lblSearchText: UILabel!
    @IBOutlet weak var lblResultCount: UILabel!
    @IBOutlet weak var btnSort: UIButton!
    var viewModel: SearchVModeling?
    var item: SearchResult?
    var page = 1
    var arrayProduct = [Product]()
    var filterValue = FilterValue()
    
    weak var delegate: ExploreDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        self.setup()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

   // MARK: - Private functions
    
    private func setup() {
        self.recheckVM()
        self.collectionView.register(ExplorePopularCollectionCell.self)
        if let name = item?.itemName {
            self.lblSearchText.text = name
        }
        
        if let search = self.item, let subCategory = search.categoryName, let subCatId = search.categoryId {
            self.filterValue.subCatId = subCatId
            self.filterValue.subCategory = subCategory
        }
        
        if let search = self.item, let category = search.rootCategoryName, let catId = search.rootCategoryId {
            self.filterValue.category = category
            self.filterValue.cateId = catId
        }
        
        self.getSearchResultDetail()
    }
    
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SearchVM()
        }        
    }
    
    private func updateFilterValue(updatedFilter: FilterValue) {
        self.filterValue.maxPrice = updatedFilter.maxPrice
        self.filterValue.minPrice = updatedFilter.minPrice
        self.filterValue.condition = updatedFilter.condition
        self.filterValue.sellerType = updatedFilter.sellerType
        self.filterValue.shipping = updatedFilter.shipping
        self.filterValue.cateId = updatedFilter.cateId
        self.filterValue.subCatId = updatedFilter.subCatId
        self.filterValue.category = updatedFilter.category
        self.filterValue.subCategory = updatedFilter.subCategory
        self.page = 1
        self.getSearchResultDetail()
        
    }
    
    func removeProductFromDataSource(itemId: Int) {
        var index = 0
        for product in self.arrayProduct {
            if itemId == product.itemId {
                self.arrayProduct.remove(at: index)
                break
            }
            index += 1
        }
        self.collectionView.reloadData()
    }
    
    func updateLikeInDataSource(itemId: Int, isLike: Bool) {
        var index = 0
        for product in self.arrayProduct {
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
                self.arrayProduct[index] = product
                break
            }
            index += 1
        }
        self.collectionView.reloadData()
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

    @IBAction func tapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tapSort(_ sender: Any) {
        
        Alert.showAlertWithActionWithCancel(title: nil, message: nil, style: .actionSheet, actionTitles: ["Price low to high".localize(), "Price high to low".localize(), "Clear sorting".localize()], showCancel: true, deleteTitle: nil) { action in
            if let title = action.title {
                switch title {
                case "Price low to high".localize() : self.filterValue.filterKey = 1
                case "Price high to low".localize() : self.filterValue.filterKey = 2
                default: self.filterValue.filterKey = 0
                }
            }
            self.getSearchResultDetail()
        }
        
        
    }
    
    @IBAction func tapSearch(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapFilter(_ sender: Any) {
        if let filterVC = DIConfigurator.sharedInst().getFilterVC() {
            filterVC.filterValue = self.filterValue
            self.navigationController?.pushViewController(filterVC, animated: true)
            filterVC.updateFilter = { [weak self] filter in
                guard let strongSelf = self else { return }
                strongSelf.updateFilterValue(updatedFilter: filter)
            }
        }
    }
    
    func getSearchResultDetail() {
        self.viewModel?.requestToSearchDetail(param: self.getParam(), completions: {[weak self] (array, count) in
            guard let strongSelf = self else { return }
            if count > 0 {
                let item = count > 1 ? "items".localize() : "item".localize()
                let found = "found".localize()
                strongSelf.lblResultCount.text = "\(count) \(item) \(found) "
            } else {
                strongSelf.lblResultCount.text = ""
            }
            if strongSelf.page == 1 {
                strongSelf.arrayProduct.removeAll()
            }
            strongSelf.arrayProduct.append(contentsOf: array)
            /*
             for _ in 1...10 {
             strongSelf.arrayProduct.append(contentsOf: array)
             }*/
            strongSelf.collectionView.reloadData()
            
        })
        
    }
    
    func getParam() -> [String: AnyObject] {
        if let name = item?.itemName {
            let param = ["name": name as AnyObject,
                         "categoryId": self.filterValue.subCatId as AnyObject,
                         "page": page as AnyObject,
                         "condition": filterValue.condition as AnyObject,
                         "shipping": filterValue.shipping as AnyObject,
                         "minPrice": filterValue.minPrice as AnyObject,
                         "maxPrice": filterValue.maxPrice as AnyObject,
                         "sellerType": filterValue.sellerType as AnyObject,
                         "filterKey": filterValue.filterKey as AnyObject]
            return param
        }
        
        return [:]
    }
    
    func moveToProductDetail(productId: Int) {
        if let productDetail = DIConfigurator.sharedInst().getBuyerProducDetail() {
            productDetail.productId = productId
            self.navigationController?.pushViewController(productDetail, animated: true)
        }
    }
}

extension SearchDetailViewC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 19
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayProduct.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Constant.screenWidth - 55) / 2, height: 239.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.arrayProduct[indexPath.item]
        cell.configureCell(product: product, isPopular: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.arrayProduct[indexPath.item]
        if let isAvailable = product.isAvailable, let productId = self.arrayProduct[indexPath.item].itemId {
            if isAvailable == true {
                self.moveToProductDetail(productId: productId)
            } else {
                return
            }
        }
    }
}

//MARK: - ExplorePopularCollectionCellDelegate
extension SearchDetailViewC: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        let product = self.arrayProduct[indexPath.row]
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        self.requestLikeProduct(itemId: itemId, isLike: !isLike)
    }
}

class FilterValue {
    var condition = 0 //0=>Default 1=>New 2=>Old
    var shipping = 0 //  0=>Default 1=> buyer will pay, 2=>I will pay, 3=>pickup, 4=>I will deliver, 5=>Home Delivery
    var minPrice = 0
    var maxPrice = 0
    var sellerType = 0 // 0=>Default 1=>Individual 2=>Business
    var filterKey = 0 // 1=>Price low to High 2=>Price High to Low
    var cateId = 0
    var subCatId = 0
    var category = ""
    var subCategory = ""
}
