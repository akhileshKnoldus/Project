//
//  WithdrawPopupViewC+TableView.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/17/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation

extension WithdrawPopupViewC {
    func getCellForPopupHeader(_ tableView: UITableView, indexPath: IndexPath) -> PopupHeaderCell {
        let cell: PopupHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }

    func getCellForPopupPrice(_ tableView: UITableView, indexPath: IndexPath) -> PopupPriceCell {
        let cell: PopupPriceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func getCellForWithdrawButton(_ tableView: UITableView, indexPath: IndexPath) -> WithdrawButtonCell {
        let cell: WithdrawButtonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

extension WithdrawPopupViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return self.getCellForPopupHeader(tableView, indexPath: indexPath)
        case 1: return self.getCellForPopupPrice(tableView, indexPath: indexPath)
        default: return self.getCellForWithdrawButton(tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return 50.0
        case 1: return 140.0
        default: return 105.0
        }
    }
}

//MARK: - PopupPriceCellDelegate
extension WithdrawPopupViewC: PopupPriceCellDelegate {
    func didSelectTransferMethod(isCheque: Bool) {
        self.requestType = isCheque ? WithdrawType.cheque.rawValue : WithdrawType.wireTransfer.rawValue
    }
    
    func didEnterWithdrawAmount(amount: String) {
        if let intAmount = Int(amount) {
            self.requestAmount = intAmount
        }
    }
}

//MARK: - WithdrawButtonCellDelegate
extension WithdrawPopupViewC: WithdrawButtonCellDelegate {
    func didTapWithdraw() {
        if let vModel = self.viewModel, vModel.validateData(currentBalance: self.currentBalance, withdrawAmount: self.requestAmount) {
            self.showWithdrawPopup()
        }
    }
}
