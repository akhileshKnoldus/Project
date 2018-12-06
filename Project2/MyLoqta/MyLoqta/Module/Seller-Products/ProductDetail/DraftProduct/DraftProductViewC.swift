//
//  DraftProductViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

protocol DraftProductViewDelegate: class {
    func didSaveProduct()
}

class DraftProductViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblViewDetails: UITableView!
    @IBOutlet weak var btnEdit: UIButton!
    
    //MARK: - Variables
    weak var delegate: DraftProductViewDelegate?
    var viewModel: DraftProductVModeling?
    var dataSource = [[String: Any]]()
    var imgDataSource = [String]()
    var product: Product?
    var productId = 13
    
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
        self.btnEdit.roundCorners(Constant.btnCornerRadius)
        self.recheckVM()
        self.registerCell()
        self.setupCollectionView()
        self.setupTableView()
        self.pageControl.hidesForSinglePage = true
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.headerStartOrangeColor, endColor: UIColor.headerEndOrangeColor)
        }
        self.getProductDetail()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = DraftProductVM()
        }
        if let array = self.viewModel?.getDataSource(productDetail: product) {
            self.dataSource.append(contentsOf: array)
        }
        self.tblViewDetails.reloadData()
    }
    
    private func registerCell() {
        self.collectionViewImages.register(ProductImagesCell.self)
        self.tblViewDetails.register(DraftProductNameCell.self)
        self.tblViewDetails.register(ProductDetailCell.self)
        self.tblViewDetails.register(ProductQuantityCell.self)
    }
    
    private func setupCollectionView() {
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
    }
    
    private func setupTableView() {
        self.tblViewDetails.delegate = self
        self.tblViewDetails.dataSource = self
        self.tblViewDetails.allowsSelection = false
        self.tblViewDetails.separatorStyle = .none
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
    
    private func getProductDetail() {
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
    
    private func requestPublishItem(product: Product) {
        guard let itemId = product.itemId else { return }
        guard let sellerId = Defaults[.sellerId] else { return }
        let productStatus = ProductStatus.pending.rawValue
        let param: [String: AnyObject] = ["sellerId": sellerId as AnyObject,"itemId": itemId as AnyObject, "status": productStatus as AnyObject]
        self.viewModel?.requestApiToPublishItem(param: param, completions: { (success) in
            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Item is published successfully".localize(), completeion_: { [weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    if let delegate = strongSelf.delegate {
                        delegate.didSaveProduct()
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
    
    @IBAction func tapPublish(_ sender: UIButton) {
        if let viewM = self.viewModel, viewM.validateData(productDetail: self.product) {
            guard let productDetail = self.product else { return }
            self.requestPublishItem(product: productDetail)
        } else {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please fill complete details of item".localize())
        }
    }
    
    @IBAction func tapEdit(_ sender: UIButton) {
        guard let productID = self.product?.itemId else { return }
        if let addItemVC = DIConfigurator.sharedInst().getAddItemVC() {
            addItemVC.productId = productID
            addItemVC.delegate = self
            self.navigationController?.pushViewController(addItemVC, animated: true)
        }
    }
}
