//
//  SaveItemCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SaveItemCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var btnAddItem: AVButton!
    @IBOutlet weak var btnSaveDraft: UIButton!
    
    //MARK: - Variables
    weak var delegate: AddItemProtocol?
    var isEdit = false {
        didSet {
            if isEdit {
                btnSaveDraft.isHidden = isEdit
                btnAddItem.setTitle("Save".localize(), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func tapAddToSale(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.tapButton(actionType: .addToSale)
    }
    @IBAction func tapSaveToDraft(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.tapButton(actionType: .saveAsDraft)
    }
    
    
}
