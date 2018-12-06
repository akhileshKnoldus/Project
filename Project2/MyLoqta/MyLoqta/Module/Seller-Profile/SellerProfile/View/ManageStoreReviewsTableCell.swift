//
//  ManageStoreReviewsTableCell.swift
//  MyLoqta
//
//  Created by Kirti on 7/27/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Cosmos
import ReadMoreTextView

protocol ManageStoreReviewsTableCellDelegate: class {
    func showMoreTapped(_ cell: ManageStoreReviewsTableCell)
}

class ManageStoreReviewsTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblReviewerName: AVLabel!
    @IBOutlet weak var lblReviewTime: AVLabel!
    @IBOutlet weak var imgViewItem: UIImageView!
    @IBOutlet weak var lblItemName: AVLabel!
    @IBOutlet weak var lblItemStatus: AVLabel!
    @IBOutlet weak var lblTypeOfDelivery: AVLabel!
    @IBOutlet weak var lblReviewBy: AVLabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var txtViewReviewDesc: ReadMoreTextView!
    @IBOutlet weak var seperatorDot: UIView!
    
    //MARK: - Variables
    weak var delegate: ManageStoreReviewsTableCellDelegate?
    
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
        self.viewContainer.layer.cornerRadius = 8.0
        self.imgViewItem.roundCorners(8.0)
        self.seperatorDot.roundCorners(self.seperatorDot.frame.size.width/2)
    }
    
    private func setupReview(reviewText: String, shouldTrim: Bool) {
        self.txtViewReviewDesc.text = reviewText
        self.txtViewReviewDesc.shouldTrim = shouldTrim
        self.txtViewReviewDesc.isEditable = false
        self.txtViewReviewDesc.maximumNumberOfLines = 3
        let readMoreTextAttributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.appOrangeColor,
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)
        ]
        self.txtViewReviewDesc.attributedReadMoreText = NSAttributedString(string: "\nShow more", attributes: readMoreTextAttributes)
        self.txtViewReviewDesc.setNeedsUpdateTrim()
        self.txtViewReviewDesc.layoutIfNeeded()
        self.txtViewReviewDesc.onSizeChange = { r in
            if let deleagte = self.delegate {
                deleagte.showMoreTapped(self)
            }
        }
    }
    
    //MARK: - Public Methods
    func configureCellForMyReviews(review: Reviews) {
        self.lblReviewBy.text = "Review to"
        self.lblReviewerName.text = review.sellerName
        
        if let reviewTime = review.createdAt {
            self.lblReviewTime.text = Date.timeSince(reviewTime)
        }
        
        if let ratingStar = review.ratingStar {
            self.viewRating.rating = ratingStar
        }
        
        if let reviewTxt = review.fewWordsAbout {
            self.setupReview(reviewText: reviewTxt, shouldTrim: review.isShowMore)
        }
        
        if let productImage = review.imageFirstUrl {
            self.imgViewItem.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        self.lblItemName.text = review.itemName
        
        if let condition = review.condition, let productCondition = productCondition(rawValue: condition) {
            self.lblItemStatus.text = productCondition.title
        }
        
        if let shipping = review.shipping, let productShipping = productShipping(rawValue: shipping), (productShipping == .iWillPay || productShipping == .iWillDeliver) {
            self.lblTypeOfDelivery.text = "Free delivery".localize()
            self.seperatorDot.isHidden = false
        } else {
            self.lblTypeOfDelivery.text = ""
            self.seperatorDot.isHidden = true
        }
    }
    
    func configureCellForReviewsAboutMe(review: Reviews) {
        self.lblReviewBy.text = "Review by"
        self.lblReviewerName.text = review.sellerName
        
        if let reviewTime = review.createdAt {
            self.lblReviewTime.text = Date.timeSince(reviewTime)
        }
        
        if let ratingStar = review.ratingStar {
            self.viewRating.rating = ratingStar
        }
        
        if let reviewTxt = review.fewWordsAbout {
            self.setupReview(reviewText: reviewTxt, shouldTrim: review.isShowMore)
        }
        
        if let productImage = review.imageFirstUrl {
            self.imgViewItem.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        self.lblItemName.text = review.itemName
        
        if let condition = review.condition, let productCondition = productCondition(rawValue: condition) {
            self.lblItemStatus.text = productCondition.title
        }
        
        if let shipping = review.shipping, let productShipping = productShipping(rawValue: shipping), (productShipping == .iWillPay || productShipping == .iWillDeliver) {
            self.lblTypeOfDelivery.text = "Free delivery".localize()
            self.seperatorDot.isHidden = false
        } else {
            self.lblTypeOfDelivery.text = ""
            self.seperatorDot.isHidden = true
        }
    }
    
    func configureCellForSellerReviews(review: Reviews) {
        self.lblReviewBy.text = "Review by"
        self.lblReviewerName.text = review.buyerName
        
        if let reviewTime = review.createdAt {
            self.lblReviewTime.text = Date.timeSince(reviewTime)
        }
        
        if let ratingStar = review.ratingStar {
            self.viewRating.rating = ratingStar
        }
        
        if let reviewTxt = review.fewWordsAbout {
            self.setupReview(reviewText: reviewTxt, shouldTrim: review.isShowMore)
        }
        
        if let productImage = review.imageFirstUrl {
            self.imgViewItem.setImage(urlStr: productImage, placeHolderImage: nil)
        }
        
        self.lblItemName.text = review.itemName
        
        if let condition = review.condition, let productCondition = productCondition(rawValue: condition) {
            self.lblItemStatus.text = productCondition.title
        }
        
        if let shipping = review.shipping, let productShipping = productShipping(rawValue: shipping), (productShipping == .iWillPay || productShipping == .iWillDeliver) {
            self.lblTypeOfDelivery.text = "Free delivery".localize()
            self.seperatorDot.isHidden = false
        } else {
            self.lblTypeOfDelivery.text = ""
            self.seperatorDot.isHidden = true
        }
    }
}
