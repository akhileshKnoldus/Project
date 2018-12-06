//
//  ExploreCategoriesTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol OpenExploreCategoryDelegates: class {
    func didPerformActionOnExploreCategory(indexPath: IndexPath)
}

class ExploreCategoriesTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewCategories: UICollectionView!
    
    //MARK: - Variables
    var arrayDataSource = [CategoryModel]()
    weak var delegate: OpenExploreCategoryDelegates?

    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionViewCategories.delegate = self
        self.collectionViewCategories.dataSource = self
        self.collectionViewCategories.register(ExploreCategoriesCollectionCell.self)
    }
    
    func configureCell(arrOfCategories: [CategoryModel]) {
        self.arrayDataSource = arrOfCategories
        self.collectionViewCategories.reloadData()
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension ExploreCategoriesTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constant.screenWidth/4, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: ExploreCategoriesCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(category: self.arrayDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.didPerformActionOnExploreCategory(indexPath: indexPath)
        }
    }
}
