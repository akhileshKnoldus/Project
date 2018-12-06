//
//  MyOrderCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol MyOrderCellDelegate: class {
    func didTapOnTheOrder(product: Product)
}

class MyOrderCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets

    @IBOutlet weak var btnSeeAll: UIButton!
    @IBOutlet weak var collectionViewOrders: UICollectionView!
    
    //MARK: - Variables
    weak var delegate: MyOrderCellDelegate?
    var orderDataSource = [Product]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionViewOrders.delegate = self
        self.collectionViewOrders.dataSource = self
        self.collectionViewOrders.register(OrderListCell.self)
    }
    
    //MARK: - Public Methods
    func configureView(_ orders: [Product]) {
        self.orderDataSource = orders
        self.collectionViewOrders.reloadData()
    }
    
    @objc func trackOrder(_ sender: UIButton) {
        if let indexPath = Helper.getIndexPathFor(view: sender, collectionView: self.collectionViewOrders) {
            let product = self.orderDataSource[indexPath.row]
        }
    }
}

//MARK: - CollectionViewDelegatesAndDatasource
extension MyOrderCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orderDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let orderListCell: OrderListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let product = self.orderDataSource[indexPath.row]
        orderListCell.configureView(product: product)
        orderListCell.btntrackOrder.addTarget(self, action: #selector(trackOrder(_:)), for: .touchUpInside)
        return orderListCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = self.orderDataSource[indexPath.row]
        if let delegate = delegate {
            delegate.didTapOnTheOrder(product: product)
        }
    }
}

