//
//  BuyerFeedbackViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK: - Cell Methods
extension BuyerFeedbackViewC {
    
    func getRatingCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: RateTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.dataSource[indexPath.row]
        cell.configureView(data: data)
        cell.viewStarRating.didTouchCosmos = { rating in
            self.updateRating(indexPath: indexPath, value: rating)
        }
        return cell
    }
    
     func getItemDescriptionCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: ProfileDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if let placeholder = self.dataSource[indexPath.row][Constant.keys.kTitle] as? String {
            cell.lblTitle.text = placeholder
        }
        return cell
    }
    
    func updateRating(indexPath: IndexPath, value: Double) {
        self.dataSource[indexPath.row][Constant.keys.kValue] =  value
        self.tblViewFeedback.reloadData()
    }
}

//MARK: - UITableViewDataSourceAndDelegates
extension BuyerFeedbackViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 1: return getItemDescriptionCell(tableView, indexPath: indexPath)
        default: return getRatingCell(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
}

//MARK: - ProfileDescriptionCellDelegate
extension BuyerFeedbackViewC: ProfileDescriptionCellDelegate {
    func textDidChange(_ text: String) {
        self.dataSource[1][Constant.keys.kValue] = text
    }
}
