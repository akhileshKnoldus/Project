//
//  MyCartViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class MyCartViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var lblHeader: AVLabel!
    @IBOutlet weak var tblViewCart: UITableView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnCheckout: AVButton!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: MyCartVModeling?
    var cartId: Int?
    var itemId: Int?
    var arrayCartProducts = [Product]()
    var arraySellerProducts = [Product]()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        self.getCartItems()
        self.totalView.isHidden = true
    }
    
    override func refreshApi() {
        self.getCartItems()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = MyCartVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewCart.allowsSelection = false
        self.tblViewCart.separatorStyle = .none
        self.tblViewCart.delegate = self
        self.tblViewCart.dataSource = self
    }
    
    private func registerCell() {
        self.tblViewCart.register(OtherItemCell.self)
        self.tblViewCart.register(CartOrderCell.self)
    }
    
    private func removeItemFromCartArray(itemId: Int) {
        var index = 0
        for product in self.arrayCartProducts {
            if product.itemId == itemId {
                self.arrayCartProducts.remove(at: index)
                self.tblViewCart.reloadData()
                break
            }
            index += 1
        }
    }
    
    private func updateTotalPrice() {
        var totalPrice = Double(0)
        if self.arrayCartProducts.count == 0 {
            self.totalView.isHidden = true
            self.viewNoData.isHidden = false
        } else {
            for product in self.arrayCartProducts {
                if let productPrice = product.price, let shippingCharge = product.shippingCharge, let quantity = product.cartQuantity {
                    let dblQuanty = Double(quantity)
                    totalPrice = totalPrice + ((productPrice + shippingCharge) * dblQuanty)
                }
            }
            self.totalView.isHidden = false
            self.viewNoData.isHidden = true
            let productCount = self.arrayCartProducts.count
            self.lblProductCount.text = productCount > 1 ? "(\(productCount) items)" : "(\(productCount) item)"
            let intPrice = Int(totalPrice)
            let usPrice = intPrice.withCommas()
            self.lblTotalPrice.text = usPrice
        }
    }
    
    private func updateQuantity(itemId: Int, cartQuantity: Int, totalQuantity: Int) {
        var index = 0
        for product in self.arrayCartProducts {
            if product.itemId == itemId {
                product.cartQuantity = cartQuantity
                product.currentQuantity = totalQuantity
                self.arrayCartProducts[index] = product
                self.tblViewCart.reloadData()
                break
            }
            index += 1
        }
    }
    
    private func moveToAddressListScreen() {
        if let addressListVC = DIConfigurator.sharedInst().getAddressList() {
            addressListVC.isForCheckout = true
            addressListVC.isForBuyNow = false
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }
    }
    
    //MARK: - API Methods
    
    func getCartItems() {
        self.viewModel?.getCartItems(cartType: 1, completion: { [weak self]  (cartId, cartItems)  in
            guard let strongSelf = self else { return }
            strongSelf.cartId = cartId
            strongSelf.arrayCartProducts.removeAll()
            strongSelf.arrayCartProducts.append(contentsOf: cartItems)
            strongSelf.updateTotalPrice()
            if strongSelf.arrayCartProducts.count > 0 {
                strongSelf.itemId = cartItems[0].itemId
                strongSelf.getMoreFromSeller()
                strongSelf.tblViewCart.reloadData()
            }
        })
    }
    
    func removeCartItem(itemID: Int) {
        guard let cartID = self.cartId else { return }
        self.viewModel?.requestRemoveCartItem(cartId: cartID, itemId: itemID, completion: { [weak self]  (success)  in
            guard let strongSelf = self else { return }
            strongSelf.removeItemFromCartArray(itemId: itemID)
            strongSelf.updateTotalPrice()
        })
    }
    
    func increaseItemQuantity(itemID: Int, quantity: Int) {
        self.viewModel?.requestIncreaseItemQuantity(itemId: itemID, quantity: quantity, completion: { [weak self]  (updatedQuantity)  in
            guard let strongSelf = self else { return }
            strongSelf.updateQuantity(itemId: itemID, cartQuantity: quantity, totalQuantity: updatedQuantity)
            strongSelf.updateTotalPrice()
        })
    }
    
    func getMoreFromSeller(isShowLoader: Bool = true) {
        if let itemId = self.itemId {
            self.viewModel?.getMoreFromSeller(itemId: itemId, isShowLoader: isShowLoader, completion: { [weak self]  (array) in
                guard let strongSelf = self else { return }
                strongSelf.arraySellerProducts.removeAll()
                strongSelf.arraySellerProducts.append(contentsOf: array)
                strongSelf.tblViewCart.reloadData()
            })
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapCheckout(_ sender: UIButton) {
        self.moveToAddressListScreen()
    }
    
    @IBAction func tapCrossBtn(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
