//
//  ActivityViewC+Addition.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit


extension ActivityViewC {
    //buyerOrderSuccess
    func configureCellForOrderSuccess(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForOrderSuccess(activity: activity)
        return cell
    }
    
    //sellerOrderReceive
    func configureCellForSellerOrderReceived(tableView: UITableView, indexPath: IndexPath) -> AcceptRejectActivityTableCell {
        let cell: AcceptRejectActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerOrderReceived(activity: activity)
        return cell
    }
    
    //buyerOrderAccept
    func configureCellForBuyerOrderAccept(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerOrderAccept(activity: activity)
        return cell
    }
    
    //buyerOrderReject
    func configureCellForBuyerOrderReject(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerOrderReject(activity: activity)
        return cell
    }
    
    //buyerAdminOrderReject
    func configureCellForBuyerAdminOrderReject(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerAdminOrderReject(activity: activity)
        return cell
    }
    
    //buyerOrderAcceptPickup
    func configureCellForBuyerOrderAcceptPickup(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerOrderAcceptPickup(activity: activity)
        return cell
    }
    
    //sellerOrderAssignedToDriver
    func configureCellForSellerOrderAssignedToDriver(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerOrderAssignedToDriver(activity: activity)
        return cell
    }
    
    //sellerDriverStartedPickup
    func configureCellForSellerDriverStartedPickup(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerDriverStartedPickup(activity: activity)
        return cell
    }
    
    //buyerDriverStartDelivery
    func configureCellForBuyerDriverStartDelivery(tableView: UITableView, indexPath: IndexPath) -> TrackStatusActivityTableCell {
        let cell: TrackStatusActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellItemStatus(activity: activity)
        return cell
    }
    
    //sellerDriverStartDelivery
    func configureCellForSellerDriverStartDelivery(tableView: UITableView, indexPath: IndexPath) -> TrackStatusActivityTableCell {
        let cell: TrackStatusActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellItemStatus(activity: activity)
        return cell
    }
    //buyerDriverDeliveredOrder
    func configureCellForBuyerDriverDeliveredOrder(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerDriverDeliveredOrder(activity: activity)
        return cell
    }
    
    //sellerDriverDeliveredOrder
    func configureCellForSellerDriverDeliveredOrder(tableView: UITableView, indexPath: IndexPath) -> TrackStatusActivityTableCell {
        let cell: TrackStatusActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellItemStatus(activity: activity)
        return cell
    }
    
    //sellerBuyerLeavesFeedbackCell
    func configureCellForSellerBuyerLeavesFeedback(tableView: UITableView, indexPath: IndexPath) -> LeaveFeedbackActivityTableCell {
        let cell: LeaveFeedbackActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.isReply = false
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerBuyerLeavesFeedback(activity: activity)
        return cell
    }
    
    //sellerItemBecomesActive
    func configureCellForSellerItemBecomesActive(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerItemBecomesActive(activity: activity)
        return cell
    }
    
    //sellerBuyerAsksQuestion
    func configureCellForSellerBuyerAsksQuestion(tableView: UITableView, indexPath: IndexPath) -> LeaveFeedbackActivityTableCell {
        let cell: LeaveFeedbackActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        cell.isReply = true
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForSellerBuyerAsksQuestion(activity: activity)
        return cell
    }
    
    //buyerSellerRepliesQuestion
    func configureCellForBuyerSellerRepliesQuestion(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerSellerRepliesQuestion(activity: activity)
        return cell
    }
    
    //sellerBuyerFollow
    func configureCellForSellerBuyerFollow(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerOrderReject(activity: activity)
        return cell
    }
    
    //sellerAdminOrderReject
    func configureCellForSellerAdminOrderReject(tableView: UITableView, indexPath: IndexPath) -> FollowingActivityTableCell {
        let cell: FollowingActivityTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        let arrData = self.arrayDataSource[indexPath.section]
        let activity = arrData[indexPath.row].activity
        cell.configureCellForBuyerOrderReject(activity: activity)
        return cell
    }
}

//MARK:- UITableView Delegates & Datasource Methods
extension ActivityViewC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrayDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDataSource[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = self.arrayDataSource[indexPath.section][indexPath.row].cellType
        switch cellType {
        case ActivityCell.buyerOrderSuccessCell.rawValue:
            return configureCellForOrderSuccess(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerOrderReceivedCell.rawValue:
            return configureCellForSellerOrderReceived(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerOrderAcceptCell.rawValue:
            return configureCellForBuyerOrderAccept(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerOrderRejectCell.rawValue:
            return configureCellForBuyerOrderReject(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerAdminOrderRejectCell.rawValue:
            return configureCellForBuyerAdminOrderReject(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerOrderAcceptPickupCell.rawValue:
            return configureCellForBuyerOrderAcceptPickup(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerOrderDeliveredPickupCell.rawValue:
            return UITableViewCell()
            
        case ActivityCell.sellerOrderAssignedToDriverCell.rawValue:
            return configureCellForSellerOrderAssignedToDriver(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerDriverStartedPickupCell.rawValue:
            return configureCellForSellerDriverStartedPickup(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerDriverStartDeliveryCell.rawValue:
            return configureCellForBuyerDriverStartDelivery(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerDriverStartDeliveryCell.rawValue:
            return configureCellForSellerDriverStartDelivery(tableView: tableView, indexPath: indexPath)
        
        case ActivityCell.buyerDriverDeliveredOrderCell.rawValue:
            return configureCellForBuyerDriverDeliveredOrder(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerDriverDeliveredOrderCell.rawValue:
            return configureCellForSellerDriverDeliveredOrder(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerBuyerLeavesFeedbackCell.rawValue:
            return configureCellForSellerBuyerLeavesFeedback(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerBuyerRejectsOrderCell.rawValue:
            return UITableViewCell()
            
        case ActivityCell.sellerItemBecomesActiveCell.rawValue:
            return configureCellForSellerItemBecomesActive(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerBuyerAsksQuestionCell.rawValue:
            return configureCellForSellerBuyerAsksQuestion(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.buyerSellerRepliesQuestionCell.rawValue:
            return configureCellForBuyerSellerRepliesQuestion(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerBuyerFollowCell.rawValue:
            return configureCellForSellerBuyerFollow(tableView: tableView, indexPath: indexPath)
            
        case ActivityCell.sellerAdminOrderRejectCell.rawValue:
            return configureCellForSellerAdminOrderReject(tableView: tableView, indexPath: indexPath)
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .white
//        let lblItems = UILabel(frame: CGRect(x: 16, y: 10, width: 150, height: 20))
//        lblItems.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
//        lblItems.textColor = UIColor.colorWithRGBA(redC: 16.0, greenC: 16.0, blueC: 16.0, alfa: 1.0)
//        lblItems.text = section == 0 ? "Action needed".localize() : "Other".localize()
//        let arrData = self.arrayDataSource[section]
//        if arrData.count > 0 {
//            let product = arrData[0]
//            lblItems.text = product.headerTitle
//            view.addSubview(lblItems)
//            if product.showRecent {
//                let lblRecent = UILabel(frame: CGRect(x: Constant.screenWidth - 95, y: 10, width: 80, height: 20))
//                lblRecent.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
//                lblRecent.textColor = UIColor.colorWithRGBA(redC: 248.0, greenC: 150.0, blueC: 75.0, alfa: 1.0)
//                lblRecent.textAlignment = .right
//                lblRecent.text = "Recent".localize()
//                view.addSubview(lblRecent)
//            }
//            return view
//        }
//        return nil
        
        let view = UIView()
        view.backgroundColor = .white
        let lblTitle = UILabel(frame: CGRect(x: 16, y: 20, width: 150, height: 20))
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        lblTitle.textColor = UIColor.colorWithRGBA(redC: 16.0, greenC: 16.0, blueC: 16.0, alfa: 1.0)
        lblTitle.text = section == 0 ? "Action needed".localize() : "Other".localize()
        view.addSubview(lblTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = self.arrayDataSource[indexPath.section][indexPath.row].height
        return height
//        let cellType = self.arrayDataSource[indexPath.section][indexPath.row].cellType
//        switch cellType {
//        case ActivityCell.buyerOrderSuccessCell.rawValue, ActivityCell.buyerOrderAcceptPickupCell.rawValue, ActivityCell.buyerDriverStartDeliveryCell.rawValue, ActivityCell.buyerDriverDeliveredOrderCell.rawValue :
//            self.pushToMyOrdersScreen()
//
//        case ActivityCell.buyerOrderAcceptCell.rawValue, ActivityCell.buyerOrderRejectCell.rawValue, ActivityCell.buyerAdminOrderRejectCell.rawValue:
//            self.moveToBuyerOrderDetail(indexPath: indexPath)
//
//        default: return
//        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arrayDataSource.count > 0 {
            if arrayDataSource[0].count > 0 && section == 0 {
                return 44.0
            }
            if arrayDataSource[1].count > 0 && section == 1 {
               return 44.0
            }
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellType = self.arrayDataSource[indexPath.section][indexPath.row].cellType
        switch cellType {
        case ActivityCell.buyerOrderSuccessCell.rawValue, ActivityCell.buyerOrderAcceptPickupCell.rawValue, ActivityCell.buyerDriverStartDeliveryCell.rawValue, ActivityCell.buyerDriverDeliveredOrderCell.rawValue :
            self.pushToMyOrdersScreen()
            
        case ActivityCell.buyerOrderAcceptCell.rawValue, ActivityCell.buyerOrderRejectCell.rawValue, ActivityCell.buyerAdminOrderRejectCell.rawValue:
            self.moveToBuyerOrderDetail(indexPath: indexPath)
            
        default: return
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
}

//MARK: - AcceptRejectActivityTableCellDelegate
extension ActivityViewC: AcceptRejectActivityTableCellDelegate {
    func acceptOrderTapped(cell: AcceptRejectActivityTableCell) {
        guard let indexPath = self.tblViewActivity.indexPath(for: cell) else { return }
        let activity = self.arrayDataSource[0][indexPath.row].activity
        if let orderDetailId = activity.orderDetailId {
            self.requestAcceptOrder(orderDetailId: orderDetailId)
        }
    }
    
    func rejectOrderTapped(cell: AcceptRejectActivityTableCell) {
        guard let indexPath = self.tblViewActivity.indexPath(for: cell) else { return }
        let activity = self.arrayDataSource[0][indexPath.row].activity
        if let orderDetailId = activity.orderDetailId {
            self.pushToRejectReason(orderDetailId: orderDetailId)
        }
    }
}

//MARK: - LeaveFeedbackActivityTableCellDelegate
extension ActivityViewC: LeaveFeedbackActivityTableCellDelegate {
    func replyTapped(cell: LeaveFeedbackActivityTableCell) {
        
    }
    
    func leaveFeedbackTapped(cell: LeaveFeedbackActivityTableCell) {
        guard let indexPath = self.tblViewActivity.indexPath(for: cell) else { return }
        let activity = self.arrayDataSource[0][indexPath.row].activity
        if let orderDetailId = activity.orderDetailId {
            self.pushToFeedbackView(orderDetailId: orderDetailId)
        }
    }
}

//MARK: - RejectReasonDelegate
extension ActivityViewC: RejectReasonDelegate {
    func didRejectOrder() {
        self.pageToLoad = 1
        self.getNotificationsList(page: self.pageToLoad)
    }
}
