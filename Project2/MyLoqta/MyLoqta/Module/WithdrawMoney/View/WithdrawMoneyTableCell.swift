//
//  WithdrawMoneyTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class WithdrawMoneyTableCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblWithdrawDate: UILabel!
    @IBOutlet weak var lblWithdrawAmount: AVLabel!
    @IBOutlet weak var lblWithdrawStatus: AVLabel!
    @IBOutlet weak var lblWithdrawType: AVLabel!
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setWithdrawStatus(withdrawStatus: WithdrawStatus) {
        switch withdrawStatus {
        case .pending:
            self.lblWithdrawStatus.text = "Pending".localize()
            self.lblWithdrawStatus.textColor = UIColor.appOrangeColor
        case .processing:
            self.lblWithdrawStatus.text = "Processing".localize()
            self.lblWithdrawStatus.textColor = UIColor.appOrangeColor
        case .success:
            self.lblWithdrawStatus.text = "Success".localize()
            self.lblWithdrawStatus.textColor = UIColor.successGreenColor
        }
    }
    
    //MARK: - Public Methods
    func configureView(withdrawData: Withdraw) {
        if let date = withdrawData.date {
            let withdrawDate = date.UTCToLocal(toFormat: "dd/MM/YYYY")
            self.lblWithdrawDate.text = withdrawDate
        }
        if let amount = withdrawData.requestAmount {
            let usAmount = amount.withCommas()
            self.lblWithdrawAmount.text = "\(usAmount) " + "KD".localize()
        }
//        if let status = withdrawData.paymentStatus, let withdrawStatus = WithdrawStatus(rawValue: status) {
//            self.setWithdrawStatus(withdrawStatus: withdrawStatus)
//        }
        if let type = withdrawData.requestType, let withdrawType = WithdrawType(rawValue: type) {
            self.lblWithdrawType.text = withdrawType.title
        }
    }
}
