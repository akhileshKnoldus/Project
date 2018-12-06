//
//  UserProfileCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 11/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol OpenLikeReviewViewDelegates: class {
    func didPerformActionOnLike()
    func didPerformActionOnReviews()
}

class UserProfileCell: BaseTableViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var imgView: UIImageView!
    
    weak var delegate: OpenLikeReviewViewDelegates?
    var cellType: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(cellType: Int) {
        self.cellType = cellType
        if cellType == BuyerProfileCell.myLikeCell.rawValue {
            imgView.image = #imageLiteral(resourceName: "heart_round")
            lblTitle.text = "My likes".localize()
        } else {
            imgView.image = #imageLiteral(resourceName: "sticker")
            lblTitle.text = "Reviews about me".localize()
        }
    }
    
    //MARK:- IBAction Methods
    
    @IBAction func tapToOpenLikeReviewView(_ sender: UIButton) {
        if self.cellType == BuyerProfileCell.myLikeCell.rawValue {
            if self.delegate != nil {
                self.delegate?.didPerformActionOnLike()
            }
        } else {
            if let delegate = delegate {
                delegate.didPerformActionOnReviews()
            }
        }
    }
}
