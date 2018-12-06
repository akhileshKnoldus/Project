//
//  ItemStateViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol ItemStateDelegate: class {
    func refreshScreen()
}

class ItemStateViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnPublish: AVButton!
    @IBOutlet var viewFooter: UIView!
    @IBOutlet weak var tblViewProduct: UITableView!
    @IBOutlet var viewResellFooter: UIView!
    
    @IBOutlet weak var viewFeedbackButton: UIView!
    @IBOutlet weak var btnFeedback: AVButton!
    @IBOutlet weak var viewResellButton: UIView!
    @IBOutlet weak var btnResell: AVButton!
    
    //MARK: - Variables
    weak var delegate: ItemStateDelegate?
    var viewModel: ItemStateVModeling?
    var orderDetailId: Int?
    var orderDetail: Product?
    var itemId: Int?
    var isFromNotification = false
    var arrayProductType = [[String: Any]]()
    var arrayProductDetail = [[String: Any]]()
    var arrayDriver = [[String: Any]]()
    var footerTitle: FooterTitle = .noTitle
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        //self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
        //self.setNavTitle(title: "Order Details".localize())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.tapBack()
    }
    @objc func tapBack() {
        if isFromNotification {
            AppDelegate.delegate.showHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapFeedback(_ sender: Any) {
        self.requestLeaveFeedback()
    }
    
    @IBAction func tapResell(_ sender: Any) {
        self.requestResellProduct()
    }
    
    @IBAction func tapPublishItem(_ sender: UIButton) {
        self.requestPublishItem()
    }
    
    @IBAction func tapEditItem(_ sender: UIButton) {
        guard let productID = self.orderDetail?.itemId else { return }
        if let addItemVC = DIConfigurator.sharedInst().getAddItemVC() {
            addItemVC.productId = productID
            addItemVC.delegate = self
            self.navigationController?.pushViewController(addItemVC, animated: true)
        }
    }
    
    
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.registerNib()
        self.btnEdit.roundCorners(8)
        Threads.performTaskAfterDealy(0.2, {
            self.btnPublish.isButtonActive = true
        })
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.headerStartOrangeColor, endColor: UIColor.headerEndOrangeColor)
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ItemStateVM()
        }
        
        //Threads.performTaskAfterDealy(0.2) {
            if let orderId = self.orderDetailId {
                self.viewModel?.getOrderDetail(orderId: orderId, completion: { [weak self]  order in
                    guard let strongSelf = self else { return }
                    strongSelf.processApiResponse(order: order)
                })
            }
        //}
    }
    
    private func processApiResponse(order: Product) {
        
        /*
         // Test **********************
         UserSession.sharedSession.testOrder += 1
         order.orderStatus = UserSession.sharedSession.testOrder
         order.shipping = 1
         // Test **********************
        */
        
        
        self.orderDetail = order
        
        // TODO: - todo
        // Image cell
        if let imageArray = order.imageUrl {
            self.arrayProductDetail.append([Constant.keys.kImageUrl : imageArray, Constant.keys.kCellType: CellType.imageCell])
        } else {
            self.arrayProductDetail.append([Constant.keys.kImageUrl : [""], Constant.keys.kCellType: CellType.imageCell])
        }
        
        // Rejected Cell
        if let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus), let rejectReason = order.rejectReason {
            if ( status == .cancelledByMerchant || status == .rejected_byCustomer || status == .rejected_onTheWayToSeller || status == .rejected_recievedByMerchant ) {
                self.arrayProductDetail.append([Constant.keys.kValue : rejectReason, Constant.keys.kCellType: CellType.rejectedCell])
            }
        }
        
        // Order date and Id cell
        if let orderId = order.orderId, let dateStr = order.orderDate, let itemId = order.itemId, let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus) {
            self.arrayProductDetail.append(["orderId": orderId, "date": dateStr, "orderStatus": status, "itemId": itemId,  Constant.keys.kCellType: CellType.orderIdDateCell])
        }
        
        // Order name cell
        if let name = order.itemName, let price = order.price {
            self.arrayProductDetail.append(["name": name, "price": price, Constant.keys.kCellType: CellType.itemNameCell])
        }
        
        
        // Need to add category name and subcategory name
        
        if let category = order.category, let subCat = order.subCategory {
            let value = "\(category) > \(subCat)"
            self.arrayProductType.append([Constant.keys.kTitle: "Category".localize(), Constant.keys.kValue: value])
        }
        
        // Add description
        if let desc = order.description {
            self.arrayProductType.append([Constant.keys.kTitle: "Description".localize(), Constant.keys.kValue: desc])
        }
        
        if let condition = order.condition {
            let itemCond = Helper.returnConditionTitle(condition: condition)
            self.arrayProductType.append([Constant.keys.kTitle: "Condition".localize(), Constant.keys.kValue: itemCond])
        }
        
        if let brand = order.brand {
            self.arrayProductType.append([Constant.keys.kTitle: "Brand".localize(), Constant.keys.kValue: brand])
        }
        
        if let model = order.model {
            self.arrayProductType.append([Constant.keys.kTitle: "Model".localize(), Constant.keys.kValue: model])
        }
        
        if let color = order.color {
            self.arrayProductType.append([Constant.keys.kTitle: "Color".localize(), Constant.keys.kValue: color])
        }
        
        if let quantity = order.quantity {
            self.arrayProductType.append([Constant.keys.kTitle: "Quantity".localize(), Constant.keys.kValue: "\(quantity)"])
        }
        
        // Add driver cell
        if let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus), let shipping = order.shipping, let shippingType = productShipping(rawValue: shipping) {
            if ((shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery) && (status == OrderStatus.onTheWay || status == OrderStatus.delivered)) {
                var driverName = ""; var driverImage = ""
                if let name = order.driverName {
                    driverName = name
                }
                if let image = order.driverProfileImage {
                    driverImage = image
                }
                self.arrayDriver.append(["name": driverName, "image": driverImage])
            }
        }
        
        
        self.setFooterView(order: order)
        self.tblViewProduct.reloadData()
    }
    
    
    private func setFooterView(order: Product) {
        
        if let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus), let shipping = order.shipping, let shippingType = productShipping(rawValue: shipping) {
            if (shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery) { // Add order track progress cell
                switch status {
                case .newOrder, .waitingForPickup: // No driver no bottom button
                    footerTitle = .noTitle
                case .onTheWay: // Driver info and track order bottom button
                    footerTitle = .noTitle
                case .delivered: // Driver info and item delivered bottom button
                    footerTitle = .noTitle
                case .completed: // Driver info and item leave feedback bottom button
                    footerTitle = .resell
            case .cancelledByMerchant, .rejected_byCustomer, .rejected_onTheWayToSeller, .rejected_recievedByMerchant: // Rejected
                    footerTitle = .rejected
                default: // Cancelled :
                    footerTitle = .noTitle
                }
            }
            
            if shippingType == .pickup || shippingType == .iWillDeliver {
                // Item locaion as Shipping address and no driver
                switch status {
                case .newOrder: // No driver no bottom button
                    footerTitle = .noTitle
                case .waitingForPickup:
                    footerTitle = .itemDelivered
                case .onTheWay: // Driver info and track order bottom button
                    footerTitle = .itemDelivered
                case .delivered: // Driver info and item delivered bottom button
                    footerTitle = .noTitle
                case .completed: // Driver info and item leave feedback bottom button
                    footerTitle = .resell
            case .cancelledByMerchant, .rejected_byCustomer, .rejected_onTheWayToSeller, .rejected_recievedByMerchant: // Rejected
                    footerTitle = .rejected
                default: // Cancelled :
                    footerTitle = .noTitle
                }
            }
        }
        
        if footerTitle == .noTitle {
            return
        }
        
        if footerTitle == .rejected {
            var frame = self.viewFooter.frame
            frame.size.width = Constant.screenWidth
            self.viewFooter.frame = frame
            self.tblViewProduct.tableFooterView = self.viewFooter
            return
        }
        
        if footerTitle == .resell {
            var frame = self.viewResellFooter.frame
            frame.size.width = Constant.screenWidth
            self.viewResellFooter.frame = frame
            self.tblViewProduct.tableFooterView = self.viewResellFooter
            if let isFeedback = self.orderDetail?.isSellerGivenFeedback {
                self.viewFeedbackButton.isHidden = isFeedback
                Threads.performTaskInMainQueue {
                    self.btnResell.isButtonActive = true
                }
            }
            return
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth, height: 85))
        let button = AVButton(frame: CGRect(x: 15, y: 15, width: Constant.screenWidth - 32, height: 50))
        button.isButtonActive = true
        button.setTitle(footerTitle.rawValue.localize(), for: .normal)
        button.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        button.addTarget(self, action: #selector(actionOnFooterButton), for: .touchUpInside)
        button.conrnerRadius = CGFloat(8)
        button.setTitleColor(.white, for: .normal)
        view.addSubview(button)
        self.tblViewProduct.tableFooterView = view
    }
    
    func getButtonTitle(status: OrderStatus) -> String {
        
            switch status {
            case .newOrder: return "Item delivered".localize()
            case .waitingForPickup: return "Item delivered".localize()
            case .onTheWay: return "Item delivered".localize()
            case .delivered: return "Leave feedback".localize()
            case .completed: return "Leave feedback".localize()
            case .cancelledByMerchant: return "".localize()
            case .rejected_byCustomer: return "".localize()
            case .rejected_onTheWayToSeller: return "".localize()
            case .rejected_recievedByMerchant: return "".localize()
            case .cancelled_byAdmin: return "".localize()
            }
    }
    
    private func requestLeaveFeedback() {
        if let feedbackVC = DIConfigurator.sharedInst().getSellerFeedbackViewC(), let orderDetailID = self.orderDetail?.orderDetailId {
            feedbackVC.orderDetailId = orderDetailID
            self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    //Footer Button Action
    @objc func actionOnFooterButton() {
        switch footerTitle {
        case .itemDelivered:
            self.requestMarkItemDelivered()
        case .rejected:
            self.requestPublishItem()
        case .leaveFeedBack:
            self.requestLeaveFeedback()
        default:
            break
        }
    }
    
    //MARK: - API Methods
    func requestMarkItemDelivered() {
        if let orderDetailID = self.orderDetailId {
            self.viewModel?.requestToMarkItemDelivered(orderDetailId: orderDetailID, completion: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if let delegate = strongSelf.delegate {
                    delegate.refreshScreen()
                }
                strongSelf.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    func requestPublishItem() {
        guard let orderDetailID = self.orderDetailId else { return }
        let param: [String: AnyObject] = ["orderDetailId": orderDetailID as AnyObject]
        self.viewModel?.requestApiToPublishItem(param: param, completions: { (success) in
            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Item is published successfully".localize(), completeion_: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success, let delegate = strongSelf.delegate {
                    delegate.refreshScreen()
                }
                strongSelf.navigationController?.popViewController(animated: true)
            })
        })
    }
    
    func requestResellProduct() {
        guard let itemId = self.itemId else { return }
        let sellerId = Defaults[.sellerId]
        let param: [String: AnyObject] = ["itemId": itemId as AnyObject, "sellerId": sellerId as AnyObject ]
        self.viewModel?.requestApiToResellItem(param: param, completions: { (success) in
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Item is added successfully.")
        })
    }
}

enum CellType: Int {
    
    case imageCell = 0
    case orderIdDateCell = 1
    case orderProgressCell = 2
    case rejectedCell = 3
    case itemNameCell = 4
    
}


extension ItemStateViewC: AddItemViewDelegate {
    
    func didTapSaveProduct() {
        if let delegate = delegate {
            delegate.refreshScreen()
        }
    }
}
