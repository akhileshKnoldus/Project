//
//  SellerProfileReviewMainTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 9/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerProfileReviewMainTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblViewReviews: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    
    //MARK:- Variables
    var arrReviews = [Reviews]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.tblViewReviews.isScrollEnabled = false
        self.tblViewReviews.register(ManageStoreReviewsTableCell.self)
        self.tblViewReviews.delegate = self
        self.tblViewReviews.dataSource = self
    }
    
    func configureCellForReviews(tableView: UITableView, indexPath: IndexPath) -> ManageStoreReviewsTableCell {
        let cell: ManageStoreReviewsTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let review = self.arrReviews[indexPath.row]
        cell.configureCellForSellerReviews(review: review)
        return cell
    }
    
    //MARK:- Public Methods
    func configureCell(_ arrReviews: [Reviews]) {
        self.arrReviews = arrReviews
        self.tblViewReviews.reloadData()
        
        self.viewNoData.isHidden = self.arrReviews.count > 0 ? true : false
    }
}

//MARK:- UITableView Delegates & Datasource Methods
extension SellerProfileReviewMainTableCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrReviews.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 175
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return configureCellForReviews(tableView: tableView, indexPath: indexPath)
    }
}
