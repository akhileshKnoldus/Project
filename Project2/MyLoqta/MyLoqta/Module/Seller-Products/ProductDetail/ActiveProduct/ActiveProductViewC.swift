//
//  ActiveProductViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol ActiveProductViewDelegate: class {
    func didDeactivateProduct()
}

class ActiveProductViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblViewDetails: UITableView!
    @IBOutlet weak var btnStatistics: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    //MARK: - Variables
    var viewModel: ActiveProductVModeling?
    var dataSource = [[String: Any]]()
    var imgDataSource = [String]()
    var isShowMore: Bool = true
    var productId = 13
    var product: Product?
    
    weak var delegate: ActiveProductViewDelegate?
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        self.recheckVM()
        self.registerCell()
        self.setupCollectionView()
        self.setupTableView()
        self.setupView()
        self.pageControl.hidesForSinglePage = true
        self.getProductDetail()
        self.btnEdit.addTarget(self, action: #selector(tapEdit), for: .touchUpInside)
        
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ActiveProductVM()
        }
        if let array = self.viewModel?.getDataSource(productDetail: product) {
            self.dataSource.append(contentsOf: array)
        }
        self.tblViewDetails.reloadData()
    }
    
    private func registerCell() {
        self.collectionViewImages.register(ProductImagesCell.self)
        self.tblViewDetails.register(ProductNameCell.self)
        self.tblViewDetails.register(ProductDetailCell.self)
        self.tblViewDetails.register(ProductQuantityCell.self)
        self.tblViewDetails.register(ProductQuestionCell.self)
        self.tblViewDetails.register(ProductAnswerCell.self)
        self.tblViewDetails.register(ProductDeactivateCell.self)
        self.tblViewDetails.register(DetailProductQuestion.self)
    }
    
    private func setupCollectionView() {
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
    }
    
    private func setupTableView() {
        self.tblViewDetails.delegate = self
        self.tblViewDetails.dataSource = self
        self.tblViewDetails.allowsSelection = false
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblViewDetails.frame.size.width, height: 0))
//        self.tblViewDetails.tableHeaderView = headerView
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblViewDetails.frame.size.width, height: 45))
        footerView.backgroundColor = .white
        self.tblViewDetails.tableFooterView = footerView
        self.tblViewDetails.separatorStyle = .none
    }
    
    private func setupView() {
        self.btnStatistics.roundCorners(Constant.btnCornerRadius)
        self.btnEdit.roundCorners(Constant.btnCornerRadius)
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.headerStartOrangeColor, endColor: UIColor.headerEndOrangeColor)
        }
    }
    
    private func setProductImages(_ product: Product) {
        if let arrImages = product.imageUrl {
            self.imgDataSource = arrImages
            self.pageControl.numberOfPages = self.imgDataSource.count
            self.collectionViewImages.reloadData()
        }
    }
    
    private func itemDeleted() {
        
        if let arrayVC = self.navigationController?.viewControllers {
            let count = arrayVC.count
            if count > 1, let viewC = arrayVC[(count - 2)] as? BaseViewC {
                viewC.refreshApi()
            }
        }
        Threads.performTaskAfterDealy(0.5) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    public func getProductDetail() {
        self.viewModel?.requestGetProductDetail(productId: self.productId, completion: { [weak self] (product, isDeleted) in
            guard let strongSelf = self else { return }
            if isDeleted {
                strongSelf.itemDeleted()
                return
            }
            strongSelf.product = product
            strongSelf.setProductImages(product)
            if let array = strongSelf.viewModel?.getDataSource(productDetail: product) {
                strongSelf.dataSource = []
                strongSelf.dataSource.append(contentsOf: array)
            }
            strongSelf.tblViewDetails.reloadData()
        })
    }
    
    func requestDeactivateProduct() {
        guard let itemId = self.product?.itemId else { return }
        let sellerId = Defaults[.sellerId]
        let productStatus = ProductStatus.deactivated.rawValue
        let param: [String: AnyObject] = ["sellerId": sellerId as AnyObject,"itemId": itemId as AnyObject, "status": productStatus as AnyObject]
        self.viewModel?.requestDeactivateProduct(param: param, completion: { (success) in
            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Item deactivated successfully.".localize(), completeion_: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    if let delegate = strongSelf.delegate {
                        delegate.didDeactivateProduct()
                    }
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            })
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapEdit() {
        guard let productID = self.product?.itemId else { return }
        if let addItemVC = DIConfigurator.sharedInst().getAddItemVC() {
            addItemVC.productId = productID
            self.navigationController?.pushViewController(addItemVC, animated: true)
        }
    }
    
    @IBAction func tapProductStatistics(_ sender: UIButton) {
        if let productStatsVC = DIConfigurator.sharedInst().getProductStatsViewC(), let itemName = self.product?.itemName, let arrItemImage = self.product?.imageUrl, arrItemImage.count > 0 {
            productStatsVC.itemId = self.productId
            productStatsVC.itemName = itemName
            productStatsVC.itemImage = arrItemImage[0]
            self.navigationController?.pushViewController(productStatsVC, animated: true)
        }
    }
    
    @IBAction func tapShare(_ sender: UIButton) {
        if let itemId = self.product?.itemId {
            UserSession.sharedSession.shareLink(idValue: itemId, isProduct: true, fromVC: self)
        }
    }
}
