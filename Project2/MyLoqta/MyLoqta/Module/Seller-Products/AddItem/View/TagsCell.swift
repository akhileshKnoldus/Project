//
//  TagsCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class TagsCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblPlaceholder: UILabel!
    weak var delegate: AddItemProtocol?
    var arrayKeyword = [String]()
    fileprivate let keywordCellPaddng = CGFloat(42.0)
    fileprivate let keywordCellHt = CGFloat(44.0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(KeywordCell.self)
        collectionView.register(AddKeywordCell.self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        self.arrayKeyword.removeAll()
        if let array = data[Constant.keys.kTags] as? [String] {
            self.arrayKeyword.append(contentsOf: array)
        }
        if self.arrayKeyword.count > 0 {
            self.lblPlaceholder.isHidden = false
        } else {
            self.lblPlaceholder.isHidden = true
        }
        self.collectionView.reloadData()
        
        let totoalItem = self.collectionView.numberOfItems(inSection: 0)
        let lastIndexPath = IndexPath(item: totoalItem-1, section: 0)
        self.collectionView.scrollToItem(at: lastIndexPath, at: UICollectionViewScrollPosition.left, animated: true)
    }
    
    @objc func deleteKeyword(_ sender: UIButton) {
        
        if let indexPath = Helper.getIndexPathFor(view: sender, collectionView: self.collectionView), let delegate = self.delegate {
            self.arrayKeyword.remove(at: indexPath.item)
            delegate.removeKeyword(array: self.arrayKeyword)
        }
    }
    
}

extension TagsCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayKeyword.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let totoalItem = collectionView.numberOfItems(inSection: 0)
        if indexPath.item == (totoalItem-1) {
            return self.getAddKeywordCell(collectionView: collectionView, indexPath: indexPath)
        } else {
            return self.getKeywordCell(collectionView: collectionView, indexPath: indexPath)
        }
        
    }
    
    // Get a keyword cell for tableview
    func getKeywordCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: KeywordCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.lblKeyword.text = arrayKeyword[indexPath.item]
        //cell.delegateKeywordCell = self
        cell.btnDeleteKeyword.addTarget(self, action: #selector(deleteKeyword(_:)), for: .touchUpInside)
        cell.updateConstraints()
        return cell
        
    }
    
    // Get add keyword cell for tableview
    func getAddKeywordCell(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddKeywordCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        //cell.delegateAddKeyword = self
        if self.arrayKeyword.count > 0 {
            cell.txtField.placeholder = ""
        } else {
            cell.txtField.placeholder = "Tags".localize()
        }
        cell.txtField.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totoalRow = collectionView.numberOfItems(inSection: 0)
        if indexPath.item == (totoalRow-1) {
            return CGSize(width: CGFloat(110.0), height: keywordCellHt)
        } else {
            return self.getSizeForCell(indexPath)
        }
    }
    
    // Get size for cell
    func getSizeForCell(_ indexPath: IndexPath) -> CGSize {
        let keyword = arrayKeyword[indexPath.item]
        let font =  UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        let width = keyword.size(withAttributes: [.font: font]).width
        return CGSize(width: width + keywordCellPaddng, height: keywordCellHt)
    }
    
}

extension TagsCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let delete = self.delegate else { return false }
        delete.openKeyword()
        return false
    }
    
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }*/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


