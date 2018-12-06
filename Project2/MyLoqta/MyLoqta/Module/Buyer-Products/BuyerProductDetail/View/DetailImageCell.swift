//
//  DetailImageCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol DetailImageCellDelegate: class {
    func didTapLike()
    func imageDisplayed(indexPath: IndexPath)
    func didPerformActionOnTappingCart()
}

class DetailImageCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnMoreOptions: UIButton!
    
    //MARK: - Variables
    weak var delegate: DetailImageCellDelegate?
    var arrayImage = [String]()
    
    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupHeaderView()
        self.setupCollectionView()
        self.pageControl.hidesForSinglePage = true
        self.pageControl.customPageControl(dotFillColor: .orange, dotBorderColor: .green, dotBorderWidth: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    
    private func setupHeaderView() {
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.headerStartOrangeColor, endColor: UIColor.headerEndOrangeColor)
        }
    }
    
    private func setupCollectionView() {
        collectionViewImage.delegate = self
        collectionViewImage.dataSource = self
        collectionViewImage.register(DetailProductCollCell.self)
    }
    
    func configureCell(product: Product)  {
        if let likeStatus = product.isLike {
            self.btnLike.isSelected = likeStatus
        }
        self.arrayImage.removeAll()
        if let array = product.imageUrl {
            self.arrayImage.append(contentsOf: array)
            self.collectionViewImage.reloadData()
            self.pageControl.numberOfPages = self.arrayImage.count
        }
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        // Your code here
//        let visibleCell = self.collectionViewImage.visibleCells
//        if visibleCell.count > 0 {
//            let cell = visibleCell[0]
//            if let index = self.collectionViewImage.indexPath(for: cell) {
//                self.pageControl.currentPage = index.item
//            }
//        }
//    }
    
    //MARK:- IBAction Methods
    @IBAction func tapLikeProduct(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapLike()
        }
    }
    
    @IBAction func tapOpenCart(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didPerformActionOnTappingCart()
        }
    }
}

extension DetailImageCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print((Constant.htRation * imageHeight))
        return CGSize(width: Constant.screenWidth, height: (Constant.htRation * imageHeight))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailProductCollCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.imgViewImage.setImage(urlStr: self.arrayImage[indexPath.item], placeHolderImage: UIImage())
        if let delegate = delegate {
            delegate.imageDisplayed(indexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
}
