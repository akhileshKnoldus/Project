//
//  GraphTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/8/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class GraphTableCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var graphCollectionView: UICollectionView!
    
    //MARK: - Variables
    var graphDataSource = [GraphView]()
    var filterDuration = FilterDuration.lastWeek.rawValue
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func registerCell() {
        self.graphCollectionView.register(GraphCollectionCell.self)
        self.graphCollectionView.dataSource = self
        self.graphCollectionView.delegate = self
    }
    
    //MARK: - Public Methods
    func configureView(graphData: [GraphView], filterType: Int) {
        self.graphDataSource = graphData
        self.filterDuration = filterType
        self.graphCollectionView.reloadData()
    }
}

//MARK: - CollectionViewDataSourceAndDelegates
extension GraphTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.graphDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GraphCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let graphData = self.graphDataSource[indexPath.row]
        cell.configureView(graphData: graphData, filterType: self.filterDuration)
        cell.viewDashedLeft.isHidden = indexPath.row > 0 ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.size.width/7
        let height = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}
