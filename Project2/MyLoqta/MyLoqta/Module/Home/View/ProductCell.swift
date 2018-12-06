//
//  ProductCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProductCellDelegates: class {
    func didPerformActionOnTappingThreeDots(product: Product)
    func didPerformActionOnAddingToCart(product: Product)
    func didPerformActionOnSellerName(product: Product)
    func didPerformActionOnTappingLike(product: Product, feedType: HomeFeedsCell)
    func didPerformActionOnProductDetail(cell: ProductCell)
}

class ProductCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewSeller: UIImageView!
    @IBOutlet weak var sellerName: UILabel!
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblLikeCount: AVLabel!
    @IBOutlet weak var lblProductName: AVLabel!
    @IBOutlet weak var lblProductCondition: AVLabel!
    @IBOutlet weak var lblProductShipping: AVLabel!
    @IBOutlet weak var lblDiscountPercentage: AVLabel!
    @IBOutlet weak var lblDiscountPrice: AVLabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var collectionViewImages: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var seperatorDot: UILabel!
    
    //MARK:- Variables
    weak var delegate: ProductCellDelegates?
    var product: Product?
    var imgDataSource = [String]()
    var feedType: HomeFeedsCell = .firstFeedCell
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK:- Private Methods
    private func setUp() {
        self.registerCell()
        self.lblDiscountPrice.isHidden = true
        self.lblDiscountPercentage.isHidden = true
        self.imgViewSeller.roundCorners(self.imgViewSeller.frame.width/2)
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
        self.pageControl.hidesForSinglePage = true
    }
    
    private func registerCell() {
        self.collectionViewImages.register(ProductImagesCell.self)
    }
    
    //MARK:- Public Methods
    func configureView(product: Product) {
        self.product = product
        if let productImages = product.imageUrl {
            self.imgDataSource = productImages
            self.pageControl.numberOfPages = self.imgDataSource.count
            self.collectionViewImages.reloadData()
        }
        
        if let likeCount = product.likeCount {
            self.lblLikeCount.text = likeCount > 1 ? "\(likeCount) " + "likes".localize() : "\(likeCount) " + "like".localize()
        }
        
        self.lblProductName.text = product.itemName
        
        if let condition = product.condition {
            self.lblProductCondition.text = Helper.returnConditionTitle(condition: condition)
        }
        
        if let shipping = product.shipping, let productShipping = productShipping(rawValue: shipping), (productShipping == .iWillPay || productShipping == .iWillDeliver) {
            self.lblProductShipping.text = "Free delivery".localize()
            self.seperatorDot.isHidden = false
        } else {
            self.lblProductShipping.text = ""
            self.seperatorDot.isHidden = true
        }
        
        if let productPrice = product.price {
            let intPrice = Int(productPrice)
            let usPrice = intPrice.withCommas()
            self.lblProductPrice.text = usPrice
        }
        
        if let productLiked = product.isLike {
            self.btnLike.isSelected = productLiked
        }
        
        if let sellerName = product.sellerName {
            self.sellerName.text = sellerName
        }
        
        if let profilePic = product.profilePic {
            self.imgViewSeller.setImage(urlStr: profilePic, placeHolderImage: UIImage(named: "user_profile_placeholder"))
        } else {
            self.imgViewSeller.image = #imageLiteral(resourceName: "user_placeholder_circle")
        }
    }
    
    
    //MARK:- IBAction Methods
    
    @IBAction func tapThreeDotOption(_ sender: UIButton) {
        if self.delegate != nil {
            if let product = self.product {
            self.delegate?.didPerformActionOnTappingThreeDots(product: product)
            }
        }
    }
    
    @IBAction func tapLikeProduct(_ sender: UIButton) {
        if let delegate = delegate, let product = self.product {
            delegate.didPerformActionOnTappingLike(product: product, feedType: feedType)
        }
    }
    
    @IBAction func tapSellerName(_ sender: UIButton) {
        if let delegate = self.delegate, let product = self.product {
            delegate.didPerformActionOnSellerName(product: product)
        }
    }
    
    @IBAction func tapBtnAddToCart(_ sender: UIButton) {
        if self.delegate != nil {
            if let product = self.product {
                self.delegate?.didPerformActionOnAddingToCart(product: product)
            }
        }
    }
    
    @IBAction func tapProductDetail(_ sender: UIButton) {
        if let delegate = self.delegate {
            delegate.didPerformActionOnProductDetail(cell: self)
        }
    }
}

//MARK: - CollectionViewDataSourceAndDelegates
extension ProductCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productImageCell: ProductImagesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        productImageCell.imgViewProducts.contentMode = .scaleToFill
        productImageCell.imgViewProducts.roundCorners(Constant.viewCornerRadius)
        let imageUrl = self.imgDataSource[indexPath.row]
        productImageCell.setImage(imageUrl: imageUrl)
        return productImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
