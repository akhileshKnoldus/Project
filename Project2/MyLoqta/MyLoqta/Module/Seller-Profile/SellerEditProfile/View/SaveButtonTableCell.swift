//
//  SaveButtonTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/2/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol SaveButtonDelegate: class {
    func didTapSave()
}

class SaveButtonTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnSave: AVButton!
    
    //MARK: - Variables
    weak var delegate: SaveButtonDelegate?

    //MARK: - LifeCycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBActions
    @IBAction func tapSave(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.didTapSave()
        }
    }
}
