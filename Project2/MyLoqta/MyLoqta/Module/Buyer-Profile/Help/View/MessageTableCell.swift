//
//  MessageTableCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
protocol MessageTableCellDelegate: class {
    func updateHeightOfRow(_ cell: MessageTableCell, _ textView: UITextView)
}

class MessageTableCell: BaseTableViewCell, NibLoadableView, ReusableView {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblPlaceholder: AVLabel!
    @IBOutlet weak var txtViewValue: UITextView!
    
    //MARK: - Variables
    weak var delegate: MessageTableCellDelegate?
    
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
        self.txtViewValue.delegate = self
        self.txtViewValue.autocorrectionType = .no
        self.txtViewValue.tintColor = UIColor.gray
        self.txtViewValue.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
    }
    
    //MARK: - Selector Methods
    @objc func tapDone(sender: Any) {
        self.txtViewValue.resignFirstResponder()
    }
    
    //MARK: - Public Methods
    func configureView(placeholder: String, value: String){
        self.lblPlaceholder.text = placeholder
        self.txtViewValue.text = value
    }
}

extension MessageTableCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = self.delegate {
            deletate.updateHeightOfRow(self, textView)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.utf16.count > Constant.messageCount {
            return false
        }
        return true
    }
}
