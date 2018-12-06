//
//  ReferralViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension ReferralViewC {
    func getCellForReferralImage(_ tableView: UITableView, indexPath: IndexPath) -> ReferralImageCell {
        let cell: ReferralImageCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func getCellForReferralDetail(_ tableView: UITableView, indexPath: IndexPath) -> ReferralDetailCell {
        let cell: ReferralDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func getCellForShareButton(_ tableView: UITableView, indexPath: IndexPath) -> WithdrawButtonCell {
        let cell: WithdrawButtonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.btnWithdraw.localizeKey = "Share Link".localize()
        return cell
    }
}

extension ReferralViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.getCellForReferralImage(tableView, indexPath: indexPath)
        case 1: return self.getCellForReferralDetail(tableView, indexPath: indexPath)
        default: return self.getCellForShareButton(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 206.0
        case 1: return UITableViewAutomaticDimension
        default: return 105.0
        }
    }
}

//MARK: - WithdrawButtonCellDelegate
extension ReferralViewC: WithdrawButtonCellDelegate {
    func didTapWithdraw() {
        
    }
}

