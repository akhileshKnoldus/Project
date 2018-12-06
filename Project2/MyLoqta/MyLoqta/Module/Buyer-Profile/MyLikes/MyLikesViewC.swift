//
//  MyLikesViewC.swift
//  MyLoqta
//
//  Created by Kirti on 8/15/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol MyLikesDelegate: class {
    func didTapLike(indexPath: IndexPath)
    func didPerformActionOnTappingProduct(indexPath: IndexPath, product: Product?)
}

class MyLikesViewC: BaseViewC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var collectionViewLikes: UICollectionView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK:- Variables
    var viewModel: MyLikesVModeling?
    weak var delegate: MyLikesDelegate?
    var arrayOfProducts = [Product]()
    var page = 1
    let refresh = UIRefreshControl()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.recheckVM()
        self.registerCell()
        self.initializeRefresh()
        self.methodToGetMyLikesList(page: 1)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = MyLikesVM()
        }
    }
    
    private func registerCell() {
        self.collectionViewLikes.register(ExplorePopularCollectionCell.self)
    }
    
    private func initializeRefresh() {
        refresh.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        self.collectionViewLikes.refreshControl = refresh
    }
    
    func loadMore() {
        self.page += 1
        self.methodToGetMyLikesList(page: self.page, isShowLoader: false)
    }
    
    private func methodToGetMyLikesList(page: Int, isShowLoader: Bool = true) {
        let param: [String: AnyObject] = ["page": page as AnyObject]
        self.viewModel?.getMyLikesList(param: param, isShowLoader: isShowLoader, completion: { [weak self](arrayProducts) in
            guard let strongSelf = self else { return }
            if page == 1 {
                strongSelf.arrayOfProducts.removeAll()
            }
            strongSelf.arrayOfProducts = strongSelf.arrayOfProducts + arrayProducts
            strongSelf.collectionViewLikes.reloadData()
            
            strongSelf.viewNoData.isHidden = strongSelf.arrayOfProducts.count > 0 ? true : false
        })
    }
    
    //MARK: - Selector Methods
    @objc func pullToRefresh() {
        refresh.endRefreshing()
        self.page = 1
        self.methodToGetMyLikesList(page: self.page, isShowLoader: false)
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- ScrollView Delegates
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if abs(maximumOffset) - abs(currentOffset) <= -40 {
            self.loadMore()
        }
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension MyLikesViewC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ExplorePopularCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let product = self.arrayOfProducts[indexPath.item]
        cell.configureCell(product: product, isPopular: true)
        cell.btnLike.isHidden = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayOfProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 162.0, height: 239.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = arrayOfProducts[indexPath.item]
        if let isAvailable = product.isAvailable , isAvailable == true {
            if let buyerDetail = DIConfigurator.sharedInst().getBuyerProducDetail(), let itemId = product.itemId {
                buyerDetail.productId = itemId
                self.navigationController?.pushViewController(buyerDetail, animated: true)
            }
        }
    }
}

//MARK:- ExplorePopularCollectionCellDelegate Methods
extension MyLikesViewC: ExplorePopularCollectionCellDelegate {
    func didLikeProduct(_ cell: ExplorePopularCollectionCell) {
        guard let indexPath = self.collectionViewLikes.indexPath(for: cell) else { return }
        if let delegate = delegate {
            delegate.didTapLike(indexPath: indexPath)
        }
    }
}


