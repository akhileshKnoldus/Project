//
//  ProfileDescriptionCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol ProfileDescriptionCellDelegate: class {
    func textDidChange(_ text: String)
}

class ProfileDescriptionCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var txtViewInfo: UITextView!
    
    //MARK: - Variables
    var delegate: ProfileDescriptionCellDelegate?
    
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
        self.txtViewInfo.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
        self.txtViewInfo.delegate = self
    }
    
    //MARK: - Public Methods
    func setDataOnTextView() {
        
    }
    
    //MARK: - Selector Methods
    @objc func tapDone() {
        self.txtViewInfo.resignFirstResponder()
    }
}

//MARK: - TextView Delegates
extension ProfileDescriptionCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let str = (textView.text as NSString?)?.replacingCharacters(in: range, with: text), let delegate = delegate {
            if str.count > Constant.validation.kAboutYouLength {
                return false
            }
            delegate.textDidChange(str)
        }
        return true
    }
}
