//
//  ItemImageTableCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 13/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemImageTableCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    var arrayImage = [String]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //ProductImagesCell
    
    func configureCell(data: [String: Any]) {
        if let imageUrl = data[Constant.keys.kImageUrl] as? [String] {
            //self.imgView.setImage(urlStr: imageUrl, placeHolderImage: UIImage())
            arrayImage.append(contentsOf: imageUrl)
            self.pageControl.numberOfPages = self.arrayImage.count
            collectionView.register(ProductImagesCell.self)
            collectionView.isPagingEnabled = true
            collectionView.reloadData()
        }
    }
    
}

extension ItemImageTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //(191.0 * Constant.htRation)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print((Constant.htRation * imageHeight))
        return CGSize(width: Constant.screenWidth, height: (191.0 * Constant.htRation))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ProductImagesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.imgViewProducts.setImage(urlStr: self.arrayImage[indexPath.item], placeHolderImage: UIImage())
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
}
