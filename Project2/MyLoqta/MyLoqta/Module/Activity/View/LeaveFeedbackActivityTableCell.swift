//
//  LeaveFeedbackActivityTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol LeaveFeedbackActivityTableCellDelegate: class {
    func leaveFeedbackTapped(cell: LeaveFeedbackActivityTableCell)
    func replyTapped(cell: LeaveFeedbackActivityTableCell)
}

class LeaveFeedbackActivityTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnFeedback: AVButton!
    //ConstraintOutlets
    @IBOutlet weak var cnstrntBtnFeedbackWidth: NSLayoutConstraint!
    
    //MARK: - Variables
    weak var delegate: LeaveFeedbackActivityTableCellDelegate?
    var isReply = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setupView() {
        self.imgViewProduct.roundCorners(4.0)
        self.configureViewForShadow()
        if isReply {
            self.btnFeedback.localizeKey = "Reply".localize()
            self.cnstrntBtnFeedbackWidth.constant = 70.0
        } else {
            self.btnFeedback.localizeKey = "Leave feedback".localize()
            self.cnstrntBtnFeedbackWidth.constant = 115.0
        }
    }
    
    private func configureViewForShadow() {
        self.viewShadow.layer.shadowColor = UIColor.gray.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.viewShadow.layer.shadowOpacity = 0.2
        self.viewShadow.layer.shadowRadius = 5.0
        self.viewShadow.layer.cornerRadius = 8.0
        self.viewContainer.layer.cornerRadius = 8.0
    }
    
    //MARK:- IBActions
    
    @IBAction func tapBtnLeaveFeedback(_ sender: AVButton) {
        if let delegate = delegate {
            if isReply {
               delegate.replyTapped(cell: self)
            } else {
                delegate.leaveFeedbackTapped(cell: self)
            }
        }
    }
    
    //MARK:- Public Methods
    func configureCellForSellerBuyerLeavesFeedback(activity: Activity) {
        if let itemName = activity.itemName, let buyerName = activity.buyerName {
            let yourItem = "Your item".localize()
            let hasSold = "has been sold to".localize()
            let finalText = yourItem + " \(itemName) " + hasSold + " \(buyerName)."
            self.lblDescription.text = finalText
        }
    }
    
    func configureCellForSellerBuyerAsksQuestion(activity: Activity) {
        if let buyerName = activity.buyerName, let question = activity.question {
            let commentedOn = "commented on".localize()
            let finalText = buyerName + " \(commentedOn): " + question
            self.lblDescription.text = finalText
        }
    }
}
