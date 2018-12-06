//
//  ProductListViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension SellerProductListViewC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? SellerProductCell.buyerPickupOrderCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let arrData = self.arrayDataSource[indexPath.section]
        return arrData[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arrData = self.arrayDataSource[indexPath.section]
        let cellType = arrData[indexPath.row].cellType
        switch cellType {
            
        case SellerProductCell.activeProductCell.rawValue:
            return configureCellForActiveProducts(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.reviewProductCell.rawValue:
            return configureCellForReviewProducts(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.rejectedProductCell.rawValue:
            return configureCellForRejectedProducts(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.newOrderCell.rawValue:
            return configureCellForNewOrders(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.readyForPickupOrderCell.rawValue:
            return configureCellForReadyPickupOrders(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.buyerPickupOrderCell.rawValue:
            return configureCellForBuyerPickupOrders(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.driverDropOrderCell.rawValue:
            return configureCellForDriverDropOrders(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.rejectedOrderCell.rawValue:
            return configureCellForRejectedOrders(tableView: tableView, indexPath: indexPath)
            
        case SellerProductCell.draftProductCell.rawValue:
            return configureCellForDraftProducts(tableView: tableView, indexPath: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arrData = self.arrayDataSource[indexPath.section]
        let cellType = arrData[indexPath.row].cellType
        let product = arrData[indexPath.row].product
        switch cellType {
            
        case SellerProductCell.activeProductCell.rawValue:
            self.pushToActiveProductDetail(product: product)
            
        case SellerProductCell.reviewProductCell.rawValue:
            self.pushToReviewProductDetail(product: product)
            
        case SellerProductCell.rejectedProductCell.rawValue:
            self.pushToRejectedProductDetail(product: product)
            
        case SellerProductCell.newOrderCell.rawValue:
            break
            
        case SellerProductCell.readyForPickupOrderCell.rawValue:
            self.pushToOrderDetail(product: product)
            
        case SellerProductCell.buyerPickupOrderCell.rawValue:
            self.pushToOrderDetail(product: product)
            
        case SellerProductCell.driverDropOrderCell.rawValue:
            self.pushToOrderDetail(product: product)
            
        case SellerProductCell.rejectedOrderCell.rawValue:
            self.pushToOrderDetail(product: product)
            
        case SellerProductCell.draftProductCell.rawValue:
            self.pushToDraftProductDetail(product: product)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let lblItems = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 20))
        lblItems.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        lblItems.textColor = UIColor.colorWithRGBA(redC: 16.0, greenC: 16.0, blueC: 16.0, alfa: 1.0)
        let arrData = self.arrayDataSource[section]
        if arrData.count > 0 {
            let product = arrData[0]
            lblItems.text = product.headerTitle
            view.addSubview(lblItems)
            if product.showRecent {
                let lblRecent = UILabel(frame: CGRect(x: Constant.screenWidth - 95, y: 10, width: 80, height: 20))
                lblRecent.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
                lblRecent.textColor = UIColor.colorWithRGBA(redC: 248.0, greenC: 150.0, blueC: 75.0, alfa: 1.0)
                lblRecent.textAlignment = .right
                lblRecent.text = "Recent".localize()
                view.addSubview(lblRecent)
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
}

//MARK: - ConfigureCell Methods
extension SellerProductListViewC {
    
    //ActiveProducts
    func configureCellForActiveProducts(tableView: UITableView, indexPath: IndexPath) -> ActiveProductCell {
        let cell: ActiveProductCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.addShadow = true
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.configureCell(product: product)
        return cell
    }
    
    //ReviewProducts
    func configureCellForReviewProducts(tableView: UITableView, indexPath: IndexPath) -> ActiveProductCell {
        let cell: ActiveProductCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.addBorder = true
        cell.addShadow = false
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.configureCell(product: product)
        return cell
    }
    
    //RejectedProducts
    func configureCellForRejectedProducts(tableView: UITableView, indexPath: IndexPath) -> RejectedOrderCell {
        let cell: RejectedOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.delegate = self
        cell.configureViewForRejectedProduct(product: product)
        return cell
    }
    
    //NewOrder
    func configureCellForNewOrders(tableView: UITableView, indexPath: IndexPath) -> NewOrderCell {
        let cell: NewOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.isPickupOrder = false
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.delegate = self
        cell.configureView(product: product)
        return cell
    }
    
    //ReadyPickupOrder
    func configureCellForReadyPickupOrders(tableView: UITableView, indexPath: IndexPath) -> NewOrderCell {
        let cell: NewOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.isPickupOrder = true
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.configureView(product: product)
        return cell
    }
    
    //BuyerPickupOrders
    func configureCellForBuyerPickupOrders(tableView: UITableView, indexPath: IndexPath) -> InTransitOrderCell {
        let cell: InTransitOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.showDriver = false
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.delegate = self
        cell.configureView(product: product)
        return cell
    }
    
    //DriverDropOrders
    func configureCellForDriverDropOrders(tableView: UITableView, indexPath: IndexPath) -> InTransitOrderCell {
        let cell: InTransitOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.showDriver = true
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.configureView(product: product)
        return cell
    }
    
    //RejectedOrders
    func configureCellForRejectedOrders(tableView: UITableView, indexPath: IndexPath) -> RejectedOrderCell {
        let cell: RejectedOrderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.delegate = self
        cell.configureView(product: product)
        return cell
    }
    
    //DraftedProducts
    func configureCellForDraftProducts(tableView: UITableView, indexPath: IndexPath) -> ActiveProductCell {
        let cell: ActiveProductCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.isDraft = true
        cell.addShadow = true
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        cell.configureCell(product: product)
        return cell
    }
}

//MARK: - PushToDetail Methods
extension SellerProductListViewC {
    
    //ActiveProductDetail
    func pushToActiveProductDetail(product: Product) {
        if let activeProductVC = DIConfigurator.sharedInst().getActiveProductVC() {
            activeProductVC.productId = product.itemId ?? 0
            activeProductVC.hidesBottomBarWhenPushed = true
            activeProductVC.delegate = self
            self.navigationController?.pushViewController(activeProductVC, animated: true)
        }
    }
    
    //ReviewProductDetail
    func pushToReviewProductDetail(product: Product) {
        if let reviewVC = DIConfigurator.sharedInst().getReviewProductDetail() {
            reviewVC.productId = product.itemId ?? 0
            reviewVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
    
    //RejectedProductDetail
    func pushToRejectedProductDetail(product: Product) {
        if let orderDVC = DIConfigurator.sharedInst().getItemStateVC() {
            if let orderId = product.orderDetailId {
                orderDVC.orderDetailId = orderId
                orderDVC.delegate = self
                self.navigationController?.pushViewController(orderDVC, animated: true)
            }
        }
    }
    
    //DraftedProductDetail
    func pushToDraftProductDetail(product: Product) {
        if let darftVC = DIConfigurator.sharedInst().getDraftProductDetail() {
            darftVC.productId = product.itemId ?? 0
            darftVC.hidesBottomBarWhenPushed = true
            darftVC.delegate = self
            self.navigationController?.pushViewController(darftVC, animated: true)
        }
    }
    
    //OrderDetail
    func pushToOrderDetail(product: Product) {
        if let orderDVC = DIConfigurator.sharedInst().getItemStateVC(), let orderDetailId = product.orderDetailId {
                orderDVC.orderDetailId = orderDetailId
                orderDVC.delegate = self
                self.navigationController?.pushViewController(orderDVC, animated: true)
            }
    }
    
    func pushToRejectReason(product: Product) {
        if let rejectVC = DIConfigurator.sharedInst().getRejectReasonViewC(), let orderDetailId = product.orderDetailId {
            rejectVC.orderDetailId = orderDetailId
            rejectVC.delegate = self
            self.navigationController?.pushViewController(rejectVC, animated: true)
        }
    }
}

//MARK: - ActiveProductViewDelegate
extension SellerProductListViewC: ActiveProductViewDelegate {
    func didDeactivateProduct() {
        self.getProductsList()
    }
}

//MARK: - DraftProductViewDelegate
extension SellerProductListViewC: DraftProductViewDelegate {
    func didSaveProduct() {
        self.getDraftedProductsList()
    }
}

//MARK: - AddItemViewDelegate
extension SellerProductListViewC: AddItemViewDelegate {
    func didTapSaveProduct() {
        if btnProducts.isSelected {
            self.getProductsList()
        } else if btnOrders.isSelected {
            self.getOrdersList()
        } else {
            self.getDraftedProductsList()
        }
    }
}

//MARK: - NewOrderCellDelegate
extension SellerProductListViewC: NewOrderCellDelegate {
    func didTapAcceptOrder(_ cell: NewOrderCell) {
        guard let indexPath = self.tblViewProductList.indexPath(for: cell) else { return }
        self.requestAcceptOrder(indexPath: indexPath)
    }
    
    func didTapRejectOrder(_ cell: NewOrderCell) {
        guard let indexPath = self.tblViewProductList.indexPath(for: cell) else { return }
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        self.pushToRejectReason(product: product)
    }
}

//MARK: - RejectReasonDelegate
extension SellerProductListViewC: RejectReasonDelegate {
    func didRejectOrder() {
        self.getOrdersList()
    }
}

//MARK: - RejectedOrderCellDelegate
extension SellerProductListViewC: RejectedOrderCellDelegate {
    func didTapPublishAgain(_ cell: RejectedOrderCell) {
        guard let indexPath = self.tblViewProductList.indexPath(for: cell) else { return }
        let arrData = self.arrayDataSource[indexPath.section]
        let product = arrData[indexPath.row].product
        let cellType = arrData[indexPath.row].cellType
        if cellType == SellerProductCell.rejectedOrderCell.rawValue {
            self.requestPublishItem(product: product)
        } else {
            //Edit Item
            guard let productID = product.itemId else { return }
            if let addItemVC = DIConfigurator.sharedInst().getAddItemVC() {
                addItemVC.productId = productID
                self.navigationController?.pushViewController(addItemVC, animated: true)
            }
        }
    }
}

//MARK: - InTransitOrderCellDelegate
extension SellerProductListViewC: InTransitOrderCellDelegate {
    func didTapItemDelivered(product: Product) {
        if let orderDetailID = product.orderDetailId {
            self.requestMarkItemDelivered(orderDetailId: orderDetailID)
        }
    }
}

//MARK: - ItemStateDelegate
extension SellerProductListViewC: ItemStateDelegate {
    func refreshScreen() {
        self.getOrdersList()
    }
}
