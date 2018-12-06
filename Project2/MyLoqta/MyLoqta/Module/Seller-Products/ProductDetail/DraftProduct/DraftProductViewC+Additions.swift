//
//  DraftProductViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK: - CollectionViewDataSourceAndDelegates
extension DraftProductViewC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productImageCell: ProductImagesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let imageUrl = self.imgDataSource[indexPath.row]
        productImageCell.setImage(imageUrl: imageUrl)
        return productImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height + 20.0
        return CGSize(width: width, height: height)
    }
}

//MARK: - TableViewDataSourceAndDelegates
extension DraftProductViewC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView, indexPath: indexPath)
    }
    
    private func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let dataDict = self.dataSource[indexPath.row]
        if let cellType = dataDict[Constant.keys.kCellType] as? cellType {
            switch cellType {
            case .draftProductName:
                return getCellForProductName(tableView, indexPath: indexPath)
            case .productDetail:
                return getCellForProductDetail(tableView, indexPath: indexPath, data: dataDict)
            case .productQuantity:
                return getCellForProductQuantity(tableView, indexPath: indexPath, data: dataDict)
            default:
                break
            }
        }
        return UITableViewCell()
    }
    
    private func getCellForProductName(_ tableView: UITableView, indexPath: IndexPath) -> DraftProductNameCell {
        let cell: DraftProductNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDataOnView(self.product)
        return cell
    }
    
    private func getCellForProductDetail(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductDetailCell {
        let cell: ProductDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDataOnView(data)
        return cell
    }
    
    private func getCellForProductQuantity(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductQuantityCell {
        let cell: ProductQuantityCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDataOnView(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataDict = self.dataSource[indexPath.row]
        if let cellType = dataDict[Constant.keys.kCellType] as? cellType {
            switch cellType {
            case .productName:
                return 110.0
            case .productDetail:
                return 110.0
            default:
                break
            }
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataDict = self.dataSource[indexPath.row]
        if let cellType = dataDict[Constant.keys.kCellType] as? cellType {
            switch cellType {
            case .productName:
                return 110.0
            default:
                return UITableViewAutomaticDimension
            }
        }
        return 55.0
    }
}

extension DraftProductViewC: AddItemViewDelegate {
    
    func didTapSaveProduct() {
        if let delegate = delegate {
            delegate.didSaveProduct()
        }
    }
}
