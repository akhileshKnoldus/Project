//
//  ReviewProductViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/26/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ReviewProductViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblViewDetails: UITableView!
    
    //MARK: - Variables
    var viewModel: ReviewProductVModeling?
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
            self.viewModel = ReviewProductVM()
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
    }
    
    private func setupCollectionView() {
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
    }
    
    private func setupTableView() {
        self.tblViewDetails.delegate = self
        self.tblViewDetails.dataSource = self
        self.tblViewDetails.allowsSelection = false
        self.tblViewDetails.tableFooterView = self.getTableFooterView()
        self.tblViewDetails.separatorStyle = .none
    }
    
    private func getTableFooterView() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tblViewDetails.frame.size.width, height: 75))
        footerView.backgroundColor = .white
        let lblTitle = UILabel(frame: CGRect(x: 10, y: 30, width: self.tblViewDetails.frame.width - 20, height: 20))
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        lblTitle.textColor = UIColor.actionRedColor
        lblTitle.text = "This item will be listed after review".localize()
        footerView.addSubview(lblTitle)
        return footerView
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
    
    //MARK: - IBactions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
