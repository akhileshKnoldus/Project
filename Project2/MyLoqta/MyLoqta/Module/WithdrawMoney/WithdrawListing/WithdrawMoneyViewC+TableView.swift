//
//  WithdrawMoneyViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

extension WithdrawMoneyViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayWithdraws.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellForWithdrawHistory(tableView, indexPath:indexPath)
    }
    
    private func getCellForWithdrawHistory(_ tableView: UITableView, indexPath: IndexPath) -> WithdrawMoneyTableCell {
        let cell: WithdrawMoneyTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureView(withdrawData: arrayWithdraws[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0 /*100.0*/
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMoreData()
        }
    }
}

//MARK: - WithdrawPopupDelegate
extension WithdrawMoneyViewC: WithdrawPopupDelegate {
    func didWithdrawSuccess() {
        self.pullToRefresh() 
    }
}
