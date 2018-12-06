//
//  SellerProductListViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/19/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SellerProductListViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imgViewSellerLogo: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var btnProducts: UIButton!
    @IBOutlet weak var btnOrders: UIButton!
    @IBOutlet weak var btnDrafts: UIButton!
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var lblOrderCount: UILabel!
    @IBOutlet weak var tblViewProductList: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK: - Variables
    var viewModel: SellerProductListVModeling?
    var arrayDataSource = [[SellerProductType]]()
    var arrProductDataSource = [[SellerProductType]]()
    var arrOrderDataSource = [[SellerProductType]]()
    var arrDraftDataSource = [[SellerProductType]]()
    var cellHeights: [IndexPath : CGFloat] = [:]
    let refresh = UIRefreshControl()
    var selectOrder = false
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setDataOnView()
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        self.recheckVM()
        self.setupView()
        self.registerCell()
        self.registerView()
        self.setupTableStyle()
        self.initializeRefresh()
        Threads.performTaskAfterDealy(0.05) {
            self.drawGradientOnHeader()
        }
        self.getDataForView()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerProductListVM()
        }
    }
    
    private func setupView() {
        self.btnAddItem.roundCorners(Constant.btnCornerRadius)
        self.imgViewSellerLogo.roundCorners(self.imgViewSellerLogo.frame.size.width / 2)
        if selectOrder {
            self.btnOrders.isSelected = true
            self.btnProducts.isSelected = false
            self.btnDrafts.isSelected = false
        } else {
            self.btnProducts.isSelected = true
            self.btnOrders.isSelected = false
            self.btnDrafts.isSelected = false
        }
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.tblViewProductList.refreshControl = refresh
    }
    
//    private func getDataForView() {
//        if btnProducts.isSelected {
//            self.getProductsList()
//        } else if btnOrders.isSelected {
//            self.getOrdersList()
//        } else if btnDrafts.isSelected {
//            self.getDraftedProductsList()
//        }
//    }
    
    private func getDataForView() {
        self.getProductsList()
        self.getOrdersList()
        self.getDraftedProductsList()
//        if btnProducts.isSelected {
//            self.getProductsList()
//        } else if btnOrders.isSelected {
//            self.getOrdersList()
//        } else if btnDrafts.isSelected {
//            self.getDraftedProductsList()
//        }
    }
    
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        if btnProducts.isSelected {
            self.getProductsList(isShowLoader: false)
        } else if btnOrders.isSelected {
            self.getOrdersList(isShowLoader: false)
        } else if btnDrafts.isSelected {
            self.getDraftedProductsList(isShowLoader: false)
        }
    }
    
    private func setDataOnView() {
        if let user = Defaults[.user] {
            if let seller = user.seller {
                if let imageUrl = seller.profilePic {
                    self.imgViewSellerLogo.setImage(urlStr: imageUrl, placeHolderImage: #imageLiteral(resourceName: "user_placeholder_circle"))
                }
                if let sellerName = seller.name {
                    self.lblStoreName.text = sellerName
                }
            }
        }
    }
    
    private func drawGradientOnHeader() {
        let gradient = CAGradientLayer()
        gradient.frame = self.headerView.bounds
        gradient.colors = [UIColor.lightPurpleGradientColor.cgColor, UIColor.darkPurpleGradientColor.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.headerView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func registerCell () {
        self.tblViewProductList.register(ActiveProductCell.self)
        self.tblViewProductList.register(NewOrderCell.self)
        self.tblViewProductList.register(InTransitOrderCell.self)
        self.tblViewProductList.register(RejectedOrderCell.self)
    }
    
    private func registerView() {
        let headerNib = UINib.init(nibName: "SectionHeaderView", bundle: Bundle.main)
        self.tblViewProductList.register(headerNib, forHeaderFooterViewReuseIdentifier: "SectionHeaderView")
    }
    
    private func setupTableStyle() {
        self.tblViewProductList.delegate = self
        self.tblViewProductList.dataSource = self
        self.tblViewProductList.separatorStyle = .none
        self.tblViewProductList.reloadData()
    }
    
    private func updateOrderStatus(indexPath: IndexPath) {
        let product = self.arrayDataSource[indexPath.section][indexPath.row].product
        product.orderStatus = OrderStatus.waitingForPickup.rawValue
        self.arrayDataSource[indexPath.section][indexPath.row].product = product
        if let shipping = product.shipping, let shippingType = productShipping(rawValue: shipping) {
            if shippingType == .iWillDeliver || shippingType == .pickup {
                self.arrayDataSource[indexPath.section][indexPath.row].cellType = SellerProductCell.buyerPickupOrderCell.rawValue
                self.arrayDataSource[indexPath.section][indexPath.row].height = SellerProductCell.buyerPickupOrderCell.height
            } else {
                self.arrayDataSource[indexPath.section][indexPath.row].cellType = SellerProductCell.readyForPickupOrderCell.rawValue
                self.arrayDataSource[indexPath.section][indexPath.row].height = SellerProductCell.readyForPickupOrderCell.height
            }
        }
        self.tblViewProductList.reloadData()
    }
    
    //MARK: - API Methods
    func getProductsList(isShowLoader: Bool = true) {
        let productType = productListType.activeAndReviewProducts.rawValue
        self.viewModel?.requestGetProductsList(listType: productType, isShowLoader: isShowLoader, completion: { [weak self] (productList) in
            guard let strongSelf = self else { return }
            if let arrDataSource = strongSelf.viewModel?.getDatasourceForSellerProductList(productList: productList) {
                strongSelf.arrayDataSource = arrDataSource
                strongSelf.arrProductDataSource = arrDataSource
                //NoDataView
                strongSelf.viewNoData.isHidden = arrDataSource.count > 0 ? true : false
            }
            strongSelf.tblViewProductList.reloadData()
        })
    }
    
    func getOrdersList(isShowLoader: Bool = true) {
        self.viewModel?.requestGetOrdersList(isShowLoader: isShowLoader, completion: { [weak self] (productList) in
            guard let strongSelf = self else { return }
            if let arrDataSource = strongSelf.viewModel?.getDatasourceForSellerOrdersList(productList: productList) {
//                strongSelf.arrayDataSource = arrDataSource
                strongSelf.arrOrderDataSource = arrDataSource
                //NoDataView
//                strongSelf.viewNoData.isHidden = arrDataSource.count > 0 ? true : false
            }
            strongSelf.tblViewProductList.reloadData()
        })
    }
    
    func getDraftedProductsList(isShowLoader: Bool = true) {
        let productType = productListType.draftedProducts.rawValue
        self.viewModel?.requestGetProductsList(listType: productType, isShowLoader: isShowLoader, completion: { [weak self] (productList) in
            guard let strongSelf = self else { return }
            if let arrDataSource = strongSelf.viewModel?.getDatasourceForDraftedProductList(productList: productList) {
//                strongSelf.arrayDataSource = arrDataSource
                strongSelf.arrDraftDataSource = arrDataSource
                //NoDataView
//                strongSelf.viewNoData.isHidden = arrDataSource.count > 0 ? true : false
            }
            strongSelf.tblViewProductList.reloadData()
        })
    }
    
    func requestAcceptOrder(indexPath: IndexPath) {
        let type = 2
        let product = self.arrayDataSource[indexPath.section][indexPath.row].product
        guard let orderDetailId = product.orderDetailId else { return }
        self.viewModel?.requestToAcceptOrder(orderDetailId: orderDetailId, type: type, completion: { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.updateOrderStatus(indexPath: indexPath)
        })
    }
    
    func requestMarkItemDelivered(orderDetailId: Int) {
        let type = 4
        self.viewModel?.requestToAcceptOrder(orderDetailId: orderDetailId, type: type, completion: { [weak self] (success) in
            guard let strongSelf = self else { return }
            strongSelf.getOrdersList()
        })
    }
    
    func requestPublishItem(product: Product) {
        guard let orderDetailId = product.orderDetailId else { return }
        let param: [String: AnyObject] = ["orderDetailId": orderDetailId as AnyObject]
        self.viewModel?.requestApiToPublishItem(param: param, completions: { (success) in
            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Item is published successfully".localize(), completeion_: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.getOrdersList()
                }
            })
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapSellerImage(_ sender: UIButton) {
        guard let sellerId = Defaults[.sellerId] else { return }
        if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC() {
            //sellerProfileVC.isSelfProfile = true
            sellerProfileVC.sellerId = sellerId
            sellerProfileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(sellerProfileVC, animated: true)
        }
    }
    
    @IBAction func tapInsights(_ sender: UIButton) {
        if let insightVC = DIConfigurator.sharedInst().getInsightViewC() {
            insightVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(insightVC, animated: true)
        }
        
    }
    
    @IBAction func tapMoreOptions(_ sender: UIButton) {
        if let moreOptionsVC = DIConfigurator.sharedInst().getSellerMoreOptionsViewC() {
            let navC = UINavigationController(rootViewController: moreOptionsVC)
            navC.setNavigationBarHidden(true, animated: false)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapAddItem(_ sender: UIButton) {
        if let addItemVC = DIConfigurator.sharedInst().getAddItemVC() {
            addItemVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addItemVC, animated: true)
        }
    }
    
    @IBAction func tapProducts(_ sender: UIButton) {
//        self.getProductsList()
        self.arrayDataSource.removeAll()
        self.arrayDataSource = self.arrProductDataSource
        self.tblViewProductList.reloadData()
        self.viewNoData.isHidden = self.arrayDataSource.count > 0 ? true : false
        self.btnProducts.isSelected = true
        self.btnOrders.isSelected = false
        self.btnDrafts.isSelected = false
    }
    
    
    @IBAction func tapOrders(_ sender: UIButton) {
//        self.getOrdersList()
        self.arrayDataSource.removeAll()
        self.arrayDataSource = self.arrOrderDataSource
        self.tblViewProductList.reloadData()
        self.viewNoData.isHidden = self.arrayDataSource.count > 0 ? true : false
        self.btnProducts.isSelected = false
        self.btnOrders.isSelected = true
        self.btnDrafts.isSelected = false
        self.tblViewProductList.reloadData()
    }
    
    @IBAction func tapDrafts(_ sender: UIButton) {
//        self.getDraftedProductsList()
        self.arrayDataSource.removeAll()
        self.arrayDataSource = self.arrDraftDataSource
        self.tblViewProductList.reloadData()
        self.viewNoData.isHidden = self.arrayDataSource.count > 0 ? true : false
        self.btnProducts.isSelected = false
        self.btnOrders.isSelected = false
        self.btnDrafts.isSelected = true
    }
}
