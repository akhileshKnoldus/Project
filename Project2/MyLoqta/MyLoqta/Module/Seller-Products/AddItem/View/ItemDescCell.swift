//
//  ItemDescCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class ItemDescCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblPlaceHolder: UILabel!
    //@IBOutlet weak var txtViewDesc: AVTextView!
    @IBOutlet weak var lblTextCount: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    @IBOutlet weak var txtViewDesc: UITextView!
    var delegate: AddItemProtocol?
    
    var textCount: Int = Constant.itemDescriptionCount {
        didSet {
            if textCount == Constant.itemDescriptionCount {
                self.lblTextCount.isHidden = true
                self.lblPlaceHolder.isHidden = true
            } else {
                self.lblTextCount.isHidden = false
                self.lblTextCount.text = "\(textCount)"
                self.lblPlaceHolder.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtViewDesc.delegate = self
        self.lblPlaceHolder.text = "Description".localize()
        self.txtViewDesc.autocorrectionType = .no
        self.txtViewDesc.tintColor = UIColor.gray
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.txtViewDesc.placeholder = placeHolder
        }
        if let text = data[Constant.keys.kValue] as? String, !text.isEmpty  {
            self.txtViewDesc.text = text
            self.imgViewCheck.isHidden = false
            textCount = Constant.itemDescriptionCount - text.utf8.count
        } else {
            self.imgViewCheck.isHidden = true
            textCount = Constant.itemDescriptionCount
        }
        self.txtViewDesc.addInputAccessoryView(title: "Done".localize(), target: self, selector: #selector(tapDone(sender:)))
    }
    
    @objc func tapDone(sender: Any) {
        self.txtViewDesc.resignFirstResponder()
    }
}

extension ItemDescCell: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, !text.isEmpty {
            self.imgViewCheck.isHidden = false
        } else {
            self.imgViewCheck.isHidden = true
        }
        
        if let text = textView.text {
            textCount = Constant.itemDescriptionCount - text.utf8.count
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let deletate = self.delegate {
            deletate.updateHeightOfRow(self, textView)
        }
        if let text = textView.text {
            textCount = Constant.itemDescriptionCount - text.utf8.count
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.utf16.count > Constant.itemDescriptionCount {
            return false
        }
        return true

        /*
        if let text = textView.text, let textRange = Range(range, in: text){
            let finalText = text.replacingCharacters(in: textRange, with: text)
            if finalText.utf8.count > Constant.itemDescriptionCount {
                return false
            }
            /*
            textCount = Constant.itemDescriptionCount - finalText.utf8.count
            if textCount == 0 {
                return false
            }
            delegate.updateText(text: finalText, indexPath: nil, cell: self)*/
        }
        return true*/
    }
}
