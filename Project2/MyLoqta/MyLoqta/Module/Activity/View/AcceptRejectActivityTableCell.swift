//
//  AcceptRejectActivityTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AcceptRejectActivityTableCellDelegate: class {
    func acceptOrderTapped(cell: AcceptRejectActivityTableCell)
    func rejectOrderTapped(cell: AcceptRejectActivityTableCell)
}

class AcceptRejectActivityTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnReject: UIButton!
    
    //MARK: - Variables
    weak var delegate: AcceptRejectActivityTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setupView() {
        self.configureViewForShadow()
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
        self.btnReject.roundCorners(Constant.btnCornerRadius)
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
    
    @IBAction func tapBtnAccept(_ sender: AVButton) {
        if let delegate = delegate {
            delegate.acceptOrderTapped(cell: self)
        }
    }
    
    @IBAction func tapBtnReject(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.rejectOrderTapped(cell: self)
        }
    }
    
    //MARK:- Public Methods
    func configureCellForSellerOrderReceived(activity: Activity) {
        if let itemName = activity.itemName {
            let customerText = "Customer wants to buy your item".localize()
            let finalText = customerText + " \(itemName):"
            self.lblDescription.text = finalText
        }
        
        if let itemImage = activity.itemImage {
            self.imgViewProduct.setImage(urlStr: itemImage, placeHolderImage: nil)
        }
    }
}
