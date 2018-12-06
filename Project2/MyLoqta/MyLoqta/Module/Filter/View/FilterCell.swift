//
//  FilterCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 14/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit


class FilterCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblFilterType: UILabel!
    weak var filterDelegate: FilterDelegate?
    var arrayFilter = [String]()
    var selectedIndex = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.collectionView.register(FilterCollectionCell.self)        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(indexPath: IndexPath, filer: FilterValue) {
        
        self.arrayFilter.removeAll()
        switch indexPath.row {
        case 1:
            arrayFilter.append(contentsOf: ["New".localize(), "Used".localize()])
            self.lblFilterType.text = "Condition".localize()
            if filer.condition == 0 {
                self.selectedIndex = -1
            } else {
                self.selectedIndex = (filer.condition - 1)
            }
        case 2:
            arrayFilter.append(contentsOf: ["Business".localize(), "Individual".localize()])
            self.lblFilterType.text = "Seller Type".localize()
            if filer.sellerType == 0 {
                self.selectedIndex = -1
            } else {
                if filer.sellerType == 2 {
                    self.selectedIndex = 0
                } else if filer.sellerType == 1 {
                    self.selectedIndex = 1
                }
            }
        default:
            arrayFilter.append(contentsOf: ["Self pickup".localize(), "Home delivery".localize(), "Free".localize()])
            self.lblFilterType.text = "Delivery".localize()
            if filer.shipping == 0 {
                self.selectedIndex = -1
            } else {
                switch filer.shipping {
                case 3: self.selectedIndex = 0
                case 5: self.selectedIndex = 1
                case 2: self.selectedIndex = 2
                default: self.selectedIndex = -1
                }
            }
        }
        self.collectionView.reloadData()
    }
}

extension FilterCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getSizeForCell(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FilterCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.lblTitle.text = self.arrayFilter[indexPath.item]
        if selectedIndex == indexPath.item {
            cell.makeLayer(color: UIColor.appOrangeColor, boarderWidth: 1.0, round: 4.0)
            cell.viewBg.backgroundColor = UIColor.defaultBgColor
        } else {
            cell.makeLayer(color: UIColor.white, boarderWidth: 0.0, round: 0.0)
            cell.viewBg.backgroundColor = .white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        self.collectionView.reloadData()
        if let delegate = filterDelegate {
            delegate.selectFilterType(cell: self, selectedIndex: selectedIndex)
        }
    }
    
    // Get size for cell
    func getSizeForCell(_ indexPath: IndexPath) -> CGSize {
        let keyword = arrayFilter[indexPath.item]
        let font =  UIFont.font(name: .SFProText, weight: .Medium, size: .size_15)
        let width = keyword.size(withAttributes: [.font: font]).width
        return CGSize(width: width + 26, height: 32.0)
    }
}
