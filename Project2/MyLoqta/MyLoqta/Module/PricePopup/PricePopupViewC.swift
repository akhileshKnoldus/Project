//
//  PricePopupViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 16/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class PricePopupViewC: BaseViewC {

    //MARK:- IBOutlets
    @IBOutlet weak var cnstHtTblView: NSLayoutConstraint!
    @IBOutlet weak var tblViewPopup: UITableView!
    
    //MARK:- Variables
    var product: Product?
    var viewModel: PricePopupVModeling?
    var shippingType: Int = 3
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.tblViewPopup.register(PriceItemCell.self)
        self.tblViewPopup.register(DetailProductShipping.self)
        if self.product != nil {
            self.setHeaderView()
            self.setFooterview()
            self.tblViewPopup.reloadData()
            
            Threads.performTaskAfterDealy(0.2) {
                let height = self.tblViewPopup.contentSize.height
                self.cnstHtTblView.constant = height
            }
        }
        self.tblViewPopup.roundCorners(14)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = PricePopupVM()
        }
    }
    
    private func setFooterview() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 85))
        let button = AVButton(frame: CGRect(x: 15, y: 15, width: Constant.screenWidth - 32, height: 50))
        button.isButtonActive = true
        button.setTitle("Add to cart".localize(), for: .normal)
        button.conrnerRadius = CGFloat(8)
        button.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapAddToCart), for: .touchUpInside)
        view.addSubview(button)
        self.tblViewPopup.tableFooterView = view
    }
    
    private func setHeaderView() {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 37))
        let viewLine = UIView(frame: CGRect(x: (Constant.screenWidth - 36) / 2, y: 16, width: 36, height: 5))
        viewLine.backgroundColor = UIColor.colorWithAlpha(color: 0, alfa: 0.2)
        viewLine.roundCorners(CGFloat(2.5))
        viewHeader.addSubview(viewLine)
        
        let button = UIButton(frame: CGRect(x: (Constant.screenWidth - 36) / 2, y: 0, width: 36, height: 37))
        //button.buttonType = .custom
//        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
//        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissController))
        downSwipe.direction = .down
        button.addGestureRecognizer(downSwipe)
        
        viewHeader.addSubview(button)
        self.tblViewPopup.tableHeaderView = viewHeader
    }
    
    func requestToCheckCartSeller() {
        self.viewModel?.requestToCheckCartSeller(completion: { (sellerId) in
            if sellerId == self.product?.sellerId || sellerId == 0 {
                self.requestToAddItemToCart()
            } else {
                Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Cart contains items from a different seller. Empty the cart and add this item?".localize(), actionTitle: "Yes".localize(), showCancel: true, action: { (action) in
                    self.requestToAddItemToCart()
                })
            }
        })
    }
    
    func requestToAddItemToCart() {
        if let itemId = self.product?.itemId {
            let shipping = self.shippingType
            let param: [String: AnyObject] = ["itemId" : itemId as AnyObject, "quantity": 1 as AnyObject, "shippingType": shipping as AnyObject, "isBuyNow": 0 as AnyObject]
            self.viewModel?.requestToAddCartItem(param: param, completion: { (cartItemId) in
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Item is added to cart successfully".localize())
                    return
            })
        }
    }
    
    // MARK: - IBAction functions
    @objc func tapAddToCart() {
        self.requestToCheckCartSeller()
    }

    @IBAction func tapBack(_ sender: Any) {
        self.dismissController()
    }
    
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PricePopupViewC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.product else { return 0 }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 145
        } else {
            return 90
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: PriceItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = self.product {
                cell.configureCell(product: product)
            }
            return cell
        } else {
            let cell: DetailProductShipping = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let product = self.product {
                cell.delegate = self
                cell.configureCell(product: product)
            }
            return cell
        }
    }
}

extension PricePopupViewC: UpdateShippingTypeDelegate {
    func didPerformActionOnTappingOnHomeDelivery(selectedIndex: Int) {
        if selectedIndex == 1 {
            self.shippingType = 3
        } else {
            self.shippingType = 5
        }
    }
}
