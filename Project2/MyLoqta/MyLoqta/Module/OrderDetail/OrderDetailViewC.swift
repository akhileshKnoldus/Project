//
//  OrderDetailViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 08/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

enum FooterTitle: String {
    case noTitle = ""
    case leaveFeedBack = "Leave Feedback"
    case trackOrder = "Track order"
    case itemDelivered = "Item delivered"
    case rejected = "Publish again"
    case resell = "Resell"
}

class OrderDetailViewC: BaseViewC {

    
    @IBOutlet weak var tblViewOrderDetail: UITableView!
    var viewModel: OrderDetailVModeling?
    var orderId: Int?
    var product: Product?
    var orderDetail: Product?
    var isFromNotification = false
    
    var arrayProductType = [[String: Any]]()
    var arrayOrderStatus = [[String: Any]]()
    var arrayDriver = [[String: Any]]()
    var footerTitle: FooterTitle = .noTitle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        //self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.presentTransparentNavigationBar()
        self.setNavTitle(title: "Order details".localize())
        self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.registerNib()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = OrderDetailVM()
        }
        self.getOrderDetail()
    }
    
   
    
    private func getOrderDetail() {
        //self.orderId = 1
        if let orderId = self.orderId {
            self.viewModel?.getOrderDetail(orderId: orderId, completion: { [weak self] order in
                guard let strongSelf = self else { return }
                strongSelf.processOrderResponse(order: order)
            })
        }
    }
    
    func processOrderResponse(order: Product) {
        
        /*
        // Test **********************
        UserSession.sharedSession.testOrder  += 1
        order.orderStatus = UserSession.sharedSession.testOrder
        order.shipping = 4
        // Test **********************
        */
        
        self.orderDetail = order
        
        // Order date and Id cell
        if let orderId = order.orderId, let dateStr = order.orderDate, let itemId = order.itemId, let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus) {
            self.arrayOrderStatus.append(["orderId": orderId, "date": dateStr, "itemId": itemId, "orderStatus": status, Constant.keys.kCellType: CellType.orderIdDateCell])
        }
        
        // Order tracking progress cell
        if let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus)/*, status == OrderStatus.onTheWay*/, let shipping = order.shipping, let shippingType = productShipping(rawValue: shipping) {
            if ((shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery) && (status == .newOrder || status == .waitingForPickup ||  status == .onTheWay || status == .delivered || status == .completed)) {
                self.arrayOrderStatus.append(["orderStatus": status, Constant.keys.kCellType: CellType.orderProgressCell])
            }
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
        
        self.setFooterview(order: order)
        self.tblViewOrderDetail.reloadData()
    }
    
/*case buyerWillPay = 1
 case iWillPay = 2
 case pickup = 3
 case iWillDeliver = 4
 case homeDelivery = 5
     */
    
    private func setFooterview(order: Product) {
        
        if let oderStatus = order.orderStatus, let status = OrderStatus(rawValue: oderStatus), let shipping = order.shipping, let shippingType = productShipping(rawValue: shipping) {
            if (shippingType == .buyerWillPay || shippingType == .iWillPay || shippingType == .homeDelivery) { // Add order track progress cell
                switch status {
                case .newOrder, .waitingForPickup: // No driver no bottom button
                    footerTitle = .noTitle
                case .onTheWay: // Driver info and track order bottom button
                    footerTitle = .trackOrder
                case .delivered: // Driver info and item delivered bottom button
                    footerTitle = .leaveFeedBack
                case .completed: // Driver info and item leave feedback bottom button
                    footerTitle = .noTitle
                default: // Rejected and cancelled :
                    footerTitle = .noTitle
                }
            }
            
            if (shippingType == .pickup || shippingType == .iWillDeliver) {
                // Item locaion as Shipping address and no driver
                switch status {
                case .newOrder: // No driver no bottom button
                    footerTitle = .noTitle
                case .waitingForPickup:
                    footerTitle = .noTitle
                case .onTheWay: // Driver info and track order bottom button
                    footerTitle = .noTitle
                case .delivered: // Driver info and item delivered bottom button
                    footerTitle = .leaveFeedBack
                case .completed: // Driver info and item leave feedback bottom button
                    footerTitle = .noTitle
                default: // Rejected and cancelled :
                    footerTitle = .noTitle
                }
            }
        }
        
        if footerTitle == .noTitle {
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
        self.tblViewOrderDetail.tableFooterView = view
    }
    
    private func requestLeaveFeedback() {
        if let feedbackVC = DIConfigurator.sharedInst().getBuyerFeedbackViewC(), let orderDetailID = self.orderDetail?.orderDetailId {
                feedbackVC.orderDetailId = orderDetailID
                self.navigationController?.pushViewController(feedbackVC, animated: true)
        }
    }
    
    private func moveToTrackOrderScreen() {
        if let trackOrderVC = DIConfigurator.sharedInst().getTrackOrderViewC() {
            trackOrderVC.order = self.orderDetail
            trackOrderVC.isFromOrderDetail = true
            self.navigationController?.pushViewController(trackOrderVC, animated: true)
        }
    }
    
    //MARK: - IBAction functions
    //Footer Button Action
    @objc func actionOnFooterButton() {
        switch footerTitle {
        case .leaveFeedBack:
            self.requestLeaveFeedback()
        case .trackOrder:
            self.moveToTrackOrderScreen()
        default:
            break
        }
    }
    
    @objc func tapBack() {
        if isFromNotification {
            AppDelegate.delegate.showHome()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

