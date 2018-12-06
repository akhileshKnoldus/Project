//
//  BuyerProductDetailViewC+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 29/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import ReadMoreTextView

extension BuyerProductDetailViewC: UITableViewDelegate, UITableViewDataSource {
    
    func getHeightOfQuestionAnsCell(indexPath: IndexPath) -> CGFloat {
        
        if isAllQustLoaded, let array = self.product?.arrayQuestion {
            return UserSession.sharedSession.getHeightOfQuestionCell(question: array[indexPath.row])
        } else {
            if indexPath.row == 0 , let productDetail = self.product, let array = productDetail.arrayQuestion, array.count > 0 {
                return UserSession.sharedSession.getHeightOfQuestionCell(question: array[indexPath.row])
            } else if indexPath.row > 0 {
                return 80
            }
        }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 4
        case 1: return 3
        case 2: return self.getQuestionAnswerRow()
        case 3: return 1
        case 4: return 1
        default: return self.getOtherProductsRow()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || section == 3 {
            return 0
        }
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 20))
        view.backgroundColor = UIColor.colorWithAlpha(color: 248.0, alfa: 1.0)
        return view
    }
    
    func getHtofFesc() -> CGFloat {
        
        guard let product = self.product, let text = product.description else { return 0 }
        
        if shouldTrim {
            var ht = (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 10 )
            if ht > 64.0 {
                ht = 64.0
            }
            return (ht + 5)
        } else {
            return (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 10 )
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: return (Constant.htRation * imageHeight)
            case 1: return UITableViewAutomaticDimension
            case 2: return self.getHtofFesc()
            default: return 90
            }
        case 1: return  UITableViewAutomaticDimension
        case 2: return self.getHeightOfQuestionAnsCell(indexPath: indexPath)
            
        case 3: return 54
        case 4: return 130
        default:
            if indexPath.row == 0 {
                return (self.arrayRelatedItem.count > 0) ? 310 : 0
            } else {
                return (self.arraySellerItem.count > 0) ? 310 : 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return self.getFirstSectinCell(tableView: tableView, indexPath: indexPath)
        case 1: return self.getProductTypeCell(tableView: tableView, indexPath: indexPath)
        case 2: return self.getQstAnsCell(tableView: tableView, indexPath: indexPath)
        case 3: return self.getHaveQuestionCell(tableView: tableView, indexPath: indexPath)
        case 4: return self.getSellerCell(tableView: tableView, indexPath: indexPath)
        default: return self.getMoreProductsCell(tableView: tableView, indexPath: indexPath)
            
        }
    }
    
    func getFirstSectinCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return  self.getImageCell(tableView: tableView, indexPath: indexPath)
        case 1: return self.getNameCell(tableView: tableView, indexPath: indexPath)
        case 2: return self.getDescCell(tableView: tableView, indexPath: indexPath)
        default: return self.getShippingCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func getImageCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.btnBack.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        cell.btnMoreOptions.addTarget(self, action: #selector(tapMoreOptions), for: .touchUpInside)
        if let product = self.product {
            cell.configureCell(product: product)
        }
        return cell
    }
    
    func getNameCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let product = self.product {
            cell.configureCell(product: product)
        }
        return cell
    }
    
    
    
    func getDescCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductDesc = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let product = self.product, let text = product.description {
            //cell.configureCell(product: product)
            cell.txtViewReadMore.text = text
            cell.txtViewReadMore.shouldTrim = shouldTrim
            cell.txtViewReadMore.isEditable = false
            cell.txtViewReadMore.maximumNumberOfLines = 3
            let readMoreTextAttributes: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.foregroundColor: UIColor.appOrangeColor,
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)
            ]
            cell.txtViewReadMore.attributedReadMoreText = NSAttributedString(string: "\nShow more", attributes: readMoreTextAttributes)
            cell.txtViewReadMore.setNeedsUpdateTrim()
            cell.txtViewReadMore.layoutIfNeeded()
            cell.txtViewReadMore.onSizeChange = { [unowned tableView, unowned self] r in
                //tableView.reloadData()
                self.reloadFullText()
            }
        }
        return cell
    }
    
    func reloadFullText() {
        
        self.shouldTrim = false
        self.tblViewDetail.reloadData()
        //self.tblViewDetail.beginUpdates()
        //self.tblViewDetail.endUpdates()
    }
    
    func getShippingCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductShipping = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if let product = self.product {
            cell.configureCell(product: product)
        }
        return cell
    }
    
    func getProductTypeCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductTypeCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let product = self.product {
            cell.configureCell(product: product, indexPath: indexPath)
        }
        return cell
    }
    
    func getQstAnsCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if self.isAllQustLoaded {
            let cell: DetailProductQuestion = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let productDetail = self.product, let array = productDetail.arrayQuestion {
                cell.configreCell(question: array[indexPath.row], indexPath: indexPath, product: self.product)
            }
            return cell
        }
        
        if indexPath.row == 0 {
            let cell: DetailProductQuestion = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let productDetail = self.product, let array = productDetail.arrayQuestion {
                cell.configreCell(question: array[indexPath.row], indexPath: indexPath, product: self.product)
            }
            return cell
        } else {
            let cell: DetailProductAnswer = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.contentView.alpha = 0.57
            if let productDetail = self.product, let array = productDetail.arrayQuestion {
                cell.configureCell(question: array[indexPath.row])
            }
            cell.btnShowMore.addTarget(self, action: #selector(tapSeeMoreQuestion), for: .touchUpInside)
            return cell
        }
    }
    
    
    func getSellerCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductSeller = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if let product = self.product {
            cell.configureCell(product: product)
        }
        return cell
    }
    
    func getHaveQuestionCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: DetailProductAskQuestion = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func getMoreProductsCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell:OtherItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if self.arrayRelatedItem.count > 0 {
            switch indexPath.row {
            case 0:
                cell.lblTitle.text = "Related items".localize()
                cell.configureCell(array: arrayRelatedItem, indexPath: indexPath)
                return cell
            default:
                cell.lblTitle.text = "More from the seller".localize()
                cell.configureCell(array: arraySellerItem, indexPath: indexPath)
                return cell
            }
        } else {
            cell.lblTitle.text = "More from the seller".localize()
            cell.configureCell(array: arraySellerItem, indexPath: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.section == 4 {
            
            if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC(), let sellerId = self.product?.sellerId {
                //sellerProfileVC.isSelfProfile = false
                sellerProfileVC.sellerId = sellerId
                sellerProfileVC.delegate = self
                self.navigationController?.pushViewController(sellerProfileVC, animated: true)
            }
        }
    }
}

//MARK: - DetailImageCellDelegate
extension BuyerProductDetailViewC: DetailImageCellDelegate {
    func didTapLike() {
        if let itemId = self.product?.itemId, let isLike = self.product?.isLike {
            self.requestLikeProduct(itemId: itemId, isLike: !isLike)
        }
    }
    
    func imageDisplayed(indexPath: IndexPath) {
        if let array = self.product?.imageUrl {
            let imageUrl = array[indexPath.item]
            self.currentImageUrl = imageUrl
        }
    }
}

extension BuyerProductDetailViewC: DetailProductProtocol {
    
    func askQuestion(question: String, cell: DetailProductAskQuestion) {
        //GuestCheck
        if !UserSession.sharedSession.isLoggedIn(), let emptyProfileNavC = DIConfigurator.sharedInst().getProfileNavC(), let emptyProfileVC = emptyProfileNavC.topViewController as? EmptyProfileViewC {
            emptyProfileVC.isGuest = true
            self.navigationController?.present(emptyProfileNavC, animated: true, completion: nil)
            return
        }
        self.requestToAskQuestion(question: question)
        cell.btnSend.isHidden = true
        cell.txtFieldQuestion.text = ""
    }
}

extension BuyerProductDetailViewC: OtherItemCellDelegate {
    
    func didTapLike(cell: OtherItemCell, product: Product) {
        guard let indexPath = self.tblViewDetail.indexPath(for: cell) else { return }
        guard let itemId = product.itemId, let isLike = product.isLike else { return }
        switch indexPath.row {
        case 0:
            if self.arrayRelatedItem.count > 0 {
                self.requestLikeProductInList(itemId: itemId, isLike: !isLike, isRelatedItem: true)
            } else {
                requestLikeProductInList(itemId: itemId, isLike: !isLike, isRelatedItem: false)
            }
        case 1:
            self.requestLikeProductInList(itemId: itemId, isLike: !isLike, isRelatedItem: false)
        default:
            break
        }
    }
    
    func didTapSellAll(_ cell: OtherItemCell) {
        var productListType = productsList.relatedItems
        var categoryName = ""
        guard let indexPath = self.tblViewDetail.indexPath(for: cell) else { return }
        switch indexPath.row {
        case 0:
            if self.arrayRelatedItem.count > 0 {
                categoryName = "Related items".localize()
                productListType = productsList.relatedItems
            } else {
                categoryName = "More from the seller".localize()
                productListType = productsList.moreFromSeller
            }
            if let productListVC = DIConfigurator.sharedInst().getProductListVC(), let itemId = self.product?.itemId {
                productListVC.itemId = itemId
                productListVC.categoryName = categoryName
                productListVC.productsList = productListType
                productListVC.delegate = self
                self.navigationController?.pushViewController(productListVC, animated: true)
            }
        case 1:
            categoryName = "More from the seller".localize()
            productListType = productsList.moreFromSeller
            if let productListVC = DIConfigurator.sharedInst().getProductListVC(), let itemId = self.product?.itemId {
                productListVC.itemId = itemId
                productListVC.categoryName = categoryName
                productListVC.productsList = productListType
                productListVC.delegate = self
                self.navigationController?.pushViewController(productListVC, animated: true)
            }
        default:
            break
        }
    }
    
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?) {
        if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail(), let itemId = product?.itemId {
            buyerDetail.productId = itemId
            buyerDetail.delegate = self
            self.navigationController?.pushViewController(buyerDetail, animated: true)
        }
    }
}

extension BuyerProductDetailViewC: ExploreDelegate {
    func didLikeProduct(product: Product) {
        self.updateGlobalLike(product: product)
    }
    
    func didPerformActionOnTappingCart() {
        self.moveToMyCartViewC()
    }
}

extension BuyerProductDetailViewC: UpdateShippingTypeDelegate {
    func didPerformActionOnTappingOnHomeDelivery(selectedIndex: Int) {
        if selectedIndex == 1 {
            self.shippingType = productShipping.pickup.rawValue
        } else {
            self.shippingType = productShipping.homeDelivery.rawValue
        }
    }
}
