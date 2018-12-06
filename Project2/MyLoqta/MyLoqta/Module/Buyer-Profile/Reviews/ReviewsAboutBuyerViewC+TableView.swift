//
//  ReviewsAboutBuyerViewC+TableView.swift
//  
//
//  Created by Shivansh Jaitly on 9/5/18.
//

import UIKit

extension ReviewsAboutBuyerViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCellForReviews(tableView: tableView, indexPath: indexPath)
    }
    
    //ReviewsCell
    func configureCellForReviews(tableView: UITableView, indexPath: IndexPath) -> ManageStoreReviewsTableCell {
        let cell: ManageStoreReviewsTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let review = self.arrReviews[indexPath.row]
        cell.delegate = self
        cell.configureCellForReviewsAboutMe(review: review)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getHtofFesc(indexPath: indexPath)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
    
    func getHtofFesc(indexPath: IndexPath) -> CGFloat {
        let review = arrReviews[indexPath.row]
        guard let text = review.fewWordsAbout else { return 0.0 }
        if review.isShowMore {
            var ht = (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 10 )
            if ht > 64.0 {
                ht = 64.0
            }
            return (ht + 150)
        } else {
            return (UserSession.sharedSession.getHieghtof(text: text, width: (Constant.screenWidth - 32), font: UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)) + 150 )
        }
    }
}

//MARK: - ManageStoreReviewsTableCellDelegate
extension ReviewsAboutBuyerViewC: ManageStoreReviewsTableCellDelegate {
    func showMoreTapped(_ cell: ManageStoreReviewsTableCell) {
        guard let indexPath = self.tblViewReviews.indexPath(for: cell) else { return }
        self.arrReviews[indexPath.row].isShowMore = false
        self.tblViewReviews.reloadData()
    }
}
