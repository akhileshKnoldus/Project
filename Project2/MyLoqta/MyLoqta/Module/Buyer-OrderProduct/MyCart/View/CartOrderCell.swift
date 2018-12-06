//
//  CartOrderCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/9/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol CartOrderCellDelegate: class {
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell)
}

class CartOrderCell: BaseTableViewCell,NibLoadableView,ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblShippingType: UILabel!
    @IBOutlet weak var quantityBgView: UIView!
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnIncrease: UIButton!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    //MARK: - Variables
    weak var delegate: CartOrderCellDelegate?
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.imgViewProduct.roundCorners(Constant.viewCornerRadius)
        self.quantityBgView.roundCorners(Constant.viewCornerRadius)
    }
    
    private func setupIncDecButton(cartQuantity: Int?, currentQuantity: Int?) {
        guard let presentQty = cartQuantity, let totalQty = currentQuantity else { return }
        if presentQty == totalQty {
            self.btnIncrease.isSelected = true
            self.btnIncrease.isUserInteractionEnabled = false
        } else {
            self.btnIncrease.isSelected = false
            self.btnIncrease.isUserInteractionEnabled = true
        }
        if presentQty == 1 {
            self.btnDecrease.isSelected = true
            self.btnDecrease.isUserInteractionEnabled = false
        } else {
            self.btnDecrease.isSelected = false
            self.btnDecrease.isUserInteractionEnabled = true
        }
    }
    
    //MARK: - Public Methods
    func configureView(product: Product) {
        if let productImage = product.imageFirstUrl {
            self.imgViewProduct.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        self.lblProductName.text = product.itemName
        if let shippingType = product.shipping {
            self.lblShippingType.text = Helper.returnShippingTitle(shipping: shippingType)
        }
        if let productQuantity = product.cartQuantity {
            self.lblQuantity.text = "\(productQuantity)"
        }
        if let productPrice = product.price {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        let cartQuantity = product.cartQuantity
        let currentQuantity = product.currentQuantity
        self.setupIncDecButton(cartQuantity: cartQuantity, currentQuantity: currentQuantity)
    }
    
    //MARK: - IBActions
    @IBAction func tapDecrease(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: false, cell: self)
    }
    
    @IBAction func tapIncrease(_ sender: UIButton) {
        guard let delegate = self.delegate else { return }
        delegate.increaseQuanity(shouldIncrease: true, cell: self)
    }
}
