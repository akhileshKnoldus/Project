//
//  CheckoutViewC.swift
//  MyLoqta
//
//  Created by Kirti on 8/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class CheckoutViewC: BaseViewC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblViewCheckout: UITableView!
    @IBOutlet weak var lblCheckout: AVLabel!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var lblProductCount: AVLabel!
    @IBOutlet weak var lblTotalPrice: AVLabel!
    
    //MARK:- Variables
    var viewModel: CheckoutVModeling?
    var dictCheckoutDetail: CheckoutDetail?
    var addressId: Int?
    var shippingAddressInfo: AddressInfo?
    var cartItems = [CartInfo]()
    var walletBalance: Double?
    var arrayDatasource = [CheckoutType]()
    var isWalletUsed: Int = 0
    var isForBuyNow = Bool()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.registerCell()
        self.callApiToGetCheckoutDetail()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = CheckoutVM()
        }
    }
    
    private func registerCell() {
        self.tblViewCheckout.register(CheckoutItemTableCell.self)
        self.tblViewCheckout.register(CheckoutShippingStatusTableCell.self)
        self.tblViewCheckout.register(CheckoutLocationTableCell.self)
        self.tblViewCheckout.register(CheckoutPaymentMethodTableCell.self)
        self.tblViewCheckout.register(CheckoutTotalAmountTableCell.self)
    }
    
    private func callApiToGetCheckoutDetail() {
        if let addressID = addressId {
            let param: [String: AnyObject] = ["addressId": addressID as AnyObject, "cartType": isForBuyNow ? 2 as AnyObject : 1 as AnyObject]
            self.viewModel?.getCheckoutDetails(param, completion: { (addressInfo, cartInfo, walletBal) in
                self.shippingAddressInfo = addressInfo
                self.cartItems = cartInfo
                self.walletBalance = walletBal
                if let array = self.viewModel?.getDatasourceForCheckout(cartInfo) {
                    self.arrayDatasource = array
                }
                self.updateTotalPrice()
                self.tblViewCheckout.reloadData()
            })
        }
    }
    
    private func updateTotalPrice() {
        var totalPrice = 0
        var totalProductPrice = 0
        var totalShippingCharge = 0
        if self.cartItems.count == 0 {
            self.totalView.isHidden = true
        } else {
            for item in self.cartItems {
                if let productPrice = item.price, let quantity = item.cartQuantity {
                    totalProductPrice = totalProductPrice + (productPrice * quantity)
                }
                if let shippingCharge = item.shippingCharge, let quantity = item.cartQuantity {
                    totalShippingCharge = totalShippingCharge + (shippingCharge * quantity)
                }
            }
            totalPrice = totalProductPrice + totalShippingCharge
            self.totalView.isHidden = false
            let productCount = self.cartItems.count
            self.lblProductCount.text = productCount > 1 ? "(\(productCount) items)" : "(\(productCount) item)"
            let usTotalPrice = totalPrice.withCommas()
            self.lblTotalPrice.text = usTotalPrice
            self.tblViewCheckout.reloadData()
        }
    }
    
    //Api to Increase Quantity
    func increaseItemQuantity(itemID: Int, quantity: Int) {
        self.viewModel?.requestIncreaseItemQuantity(itemId: itemID, quantity: quantity, completion: { [weak self]  (updatedQuantity)  in
            guard let strongSelf = self else { return }
            strongSelf.updateQuantity(itemId: itemID, cartQuantity: quantity, totalQuantity: updatedQuantity)
        })
    }
    
    private func updateQuantity(itemId: Int, cartQuantity: Int, totalQuantity: Int) {
        var index = 0
        for product in self.cartItems {
            if product.itemId == itemId {
                product.cartQuantity = cartQuantity
                product.currentQuantity = totalQuantity
                self.cartItems[index] = product
                self.tblViewCheckout.reloadData()
                break
            }
            index += 1
        }
        self.updateTotalPrice()
    }
    
    func viewControllerExist(viewC: UIViewController) -> Bool {
        var isExist = false
        if (viewC is MyCartViewC) || (viewC is BuyerProductDetailViewC)   {
            isExist = true
        }
        return isExist
    }
    
    //API to Place Order
    func requestToPlaceOrder() {
        let param: [String: AnyObject] = ["addressId": self.addressId as AnyObject, "isWalletUsed": self.isWalletUsed as AnyObject, "walletBalance": self.walletBalance as AnyObject, "cartType": isForBuyNow ? 2 as AnyObject : 1 as AnyObject]
        self.viewModel?.requestToPlaceOrder(param, completion: { (success) in
            self.moveToOrderSuccessViewC()
        })
    }
    
    func moveToOrderSuccessViewC() {
        if let orderCompletedVC = DIConfigurator.sharedInst().getOrderCompletedViewC() {
            let navC = UINavigationController(rootViewController: orderCompletedVC)
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    func moveToAddressListingView() {
        if let navC = self.navigationController {
            let viewControllers: [UIViewController] = navC.viewControllers
            for viewC in viewControllers {
                if viewC is AddressListVewC {
                    navC.popToViewController(viewC, animated: true)
                    break
                }
            }
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapCancelBtn(_ sender: UIButton) {
        if let array = self.navigationController?.viewControllers {
            var shouldUpdate = false
            var newArray = array
            for viewC in array {
                if self.viewControllerExist(viewC: viewC), let index = newArray.index(of: viewC) {
                    newArray.remove(at: index+1)
                    shouldUpdate = true
                }
            }
            if shouldUpdate {
                self.navigationController?.viewControllers = newArray
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapConfirmAndPayBtn(_ sender: UIButton) {
        self.requestToPlaceOrder()
    }
}
