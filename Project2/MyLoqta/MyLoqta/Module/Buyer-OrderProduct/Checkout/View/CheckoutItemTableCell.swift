//
//  CheckoutItemTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 8/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol CheckoutCellDelegate: class {
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell)
}

class CheckoutItemTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlet
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductDesc: AVLabel!
    @IBOutlet weak var lblPrice: AVLabel!
    @IBOutlet weak var lblQuantity: AVLabel!
    @IBOutlet weak var lblShippingType: AVLabel!
    @IBOutlet weak var lblShippingPrice: AVLabel!
    @IBOutlet weak var viewQuantity: UIView!
    @IBOutlet weak var btnMinus: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    //MARK: - Variables
    weak var delegate: CheckoutCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        Threads.performTaskAfterDealy(0.1) {
            self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
            self.viewQuantity.roundCorners(Constant.viewCornerRadius)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Private Methods
    private func setupIncDecButton(cartQuantity: Int?, currentQuantity: Int?) {
        guard let presentQty = cartQuantity, let totalQty = currentQuantity else { return }
        if presentQty == totalQty {
            self.btnAdd.isSelected = true
            self.btnAdd.isUserInteractionEnabled = false
        } else {
            self.btnAdd.isSelected = false
            self.btnAdd.isUserInteractionEnabled = true
        }
        if presentQty == 1 {
            self.btnMinus.isSelected = true
            self.btnMinus.isUserInteractionEnabled = false
        } else {
            self.btnMinus.isSelected = false
            self.btnMinus.isUserInteractionEnabled = true
        }
    }
    
    //MARK:- Public Methods
    func configureCellForItems(_ cartItemInfo: CartInfo) {
        if let itemName = cartItemInfo.itemName {
            self.lblProductDesc.text = itemName
        }
        if let price = cartItemInfo.price {
            let usPrice = price.withCommas()
            self.lblPrice.text = usPrice
        }
        if let itemImage = cartItemInfo.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: itemImage, placeHolderImage: nil)
        }
        if let shippingType = cartItemInfo.shipping {
            self.lblShippingType.text = Helper.returnShippingTitle(shipping: shippingType)
        }
        if let shippingCharge = cartItemInfo.shippingCharge, shippingCharge != 0 {
            self.lblShippingPrice.isHidden = false
            self.lblShippingPrice.text = "(+" + "\(shippingCharge)" + " KD)"
        } else {
            self.lblShippingPrice.isHidden = true
        }
        if let productQuantity = cartItemInfo.cartQuantity {
            self.lblQuantity.text = "\(productQuantity)"
        }
        
        let cartQuantity = cartItemInfo.cartQuantity
        let currentQuantity = cartItemInfo.currentQuantity
        self.setupIncDecButton(cartQuantity: cartQuantity, currentQuantity: currentQuantity)
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapBtnMinus(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: false, cell: self)
    }
    
    @IBAction func tapBtnAdd(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: true, cell: self)
    }
}
