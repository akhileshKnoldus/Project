//
//  ItemPhotoCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ItemPhotoCell: BaseTableViewCell, NibLoadableView, ReusableView {

    weak var delegate: AddItemProtocol?
    var arrayImages = [[String: Any]]()
    @IBOutlet weak var viewPhotoButton: UIView!
    
    @IBOutlet weak var collectionViewImages: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
        self.collectionViewImages.register(ItemImageCell.self)
        Threads.performTaskAfterDealy(0.2) {
            self.viewPhotoButton.roundCorners(4.0)
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        
        if let array = data[Constant.keys.kImageArray] as? [[String: Any]] {
            self.arrayImages.removeAll()
            self.arrayImages.append(contentsOf: array)
            self.collectionViewImages.reloadData()
        }
    }
    
    @IBAction func tapPhoto(_ sender: Any) {
        /*
        if self.arrayImages.count >= 10 {
            return
        }*/
        guard let delegate = self.delegate else { return }
        delegate.tapImage(cell: self)
    }
    
    @objc func tapCross(sender: UIButton) {
        if let index = self.collectionViewImages.getIndexPathFor(view: sender), let delegate = self.delegate {
            delegate.removeImage(imageIndex: index.item, cell: self)
        }
    }
}

extension ItemPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 85, height: 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell: ItemImageCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arrayImages[indexPath.item])
        cell.btnCross.addTarget(self, action: #selector(tapCross(sender:)), for: .touchUpInside)
        return cell
        //return UICollectionViewCell()
    }
    
    
}
