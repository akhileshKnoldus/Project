//
//  ExploreSubCategoryTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol OpenExploreSubCategoryDelegates: class {
    func didPerformActionOnTappingCategories(indexPath: IndexPath)
}

class ExploreSubCategoryTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var collectionViewSubCategory: UICollectionView!
    
    //MARK: - Variables
    weak var delegate: OpenExploreSubCategoryDelegates?
    var subCategoryDataSource = [SubCategoryModel]()
    
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
        self.registerCell()
    }
    
    private func registerCell() {
        self.collectionViewSubCategory.register(ExploreSubCategoryCollectionCell.self)
        self.collectionViewSubCategory.delegate = self
        self.collectionViewSubCategory.dataSource = self
    }
    
    //MARK: - Public Methods
    func configureCell(arrSubCategories: [SubCategoryModel]) {
        self.subCategoryDataSource = arrSubCategories
        self.collectionViewSubCategory.reloadData()
    }
}

//MARK:- UICollectionView Delegates & Datasource Methods
extension ExploreSubCategoryTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.subCategoryDataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let name = self.subCategoryDataSource[indexPath.item].name ?? ""
        let widthCategory = name.width(withConstrainedHeight: 40.0, font: UIFont(name: "SFProText-Regular", size: 13.0) ?? UIFont())
        return CGSize(width: widthCategory + 20, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index item: \(indexPath.item)")
        let cell: ExploreSubCategoryCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let subCategory = self.subCategoryDataSource[indexPath.row]
        cell.configureDataOnView(subCategory: subCategory)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let delegate = self.delegate {
            delegate.didPerformActionOnTappingCategories(indexPath: indexPath)
        }
    }
}
