//
//  ProductDetailCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProductDetailCellDelegate: class {
    func didTapShowMore()
    func replyToAnswer(text: String, question: Question)
}

class ProductDetailCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var showMoreView: UIView!
    
    //MARK: - Variables
    
    weak var delegate: ProductDetailCellDelegate?
    var isShowMore: Bool = false {
        didSet {
            if isShowMore {
                self.drawGradientOnShowMoreView()
                self.showMoreView.isHidden = false
            } else {
                self.showMoreView.isHidden = true
            }
        }
    }
    
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
        self.showMoreView.isHidden = true
    }
    
    private func drawGradientOnShowMoreView() {
        Threads.performTaskAfterDealy(0.5) {
            let gradient = CAGradientLayer()
            gradient.frame = self.showMoreView.bounds
            gradient.colors = [UIColor.clearGradientColor.cgColor, UIColor.whiteGradientColor.cgColor]
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            self.showMoreView.layer.insertSublayer(gradient, at: 0)
        }
    }
    
    //MARK: - Public Methods
    func configureDataOnView(_ data: [String: Any]) {
        if let value = data[Constant.keys.kValue] as? String {
            self.lblValue.text = value
        }
        if let title = data[Constant.keys.kTitle] as? String {
            self.lblTitle.text = title
            
            if title == "Description" || title == "Description".localize() {
                self.lblValue.textAlignment = .justified
            } else {
                self.lblValue.textAlignment = .left
            }
        }
        
    }
    
    //MARK: - IBActions
    @IBAction func tapShowMore(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapShowMore()
        }
    }
}
