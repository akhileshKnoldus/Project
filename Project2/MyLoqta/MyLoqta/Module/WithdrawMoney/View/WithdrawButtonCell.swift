//
//  WithdrawButtonCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/17/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol WithdrawButtonCellDelegate: class {
    func didTapWithdraw()
}

class WithdrawButtonCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var btnWithdraw: AVButton!
    
    //MARK: - Variables
    weak var delegate: WithdrawButtonCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapWithdraw(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapWithdraw()
        }
    }
}
