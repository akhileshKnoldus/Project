//
//  ProductDeactivateCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProductDeactivateCellDelegate: class {
    func didTapDeactivate()
}

class ProductDeactivateCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var btnDeactivate: UIButton!
    
    //MARK: - Variables
    var delegate: ProductDeactivateCellDelegate?
    
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
        self.btnDeactivate.setTitle("Deactivate product".localize(), for: .normal)
    }
    
    
    //MARK: - IBActions
    @IBAction func tapDeactivateProduct(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapDeactivate()
        }
    }
}
