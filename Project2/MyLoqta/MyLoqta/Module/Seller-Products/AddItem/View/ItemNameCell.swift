//
//  ItemNameCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 21/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol AddItemProtocol: class {
    func updateText(text: String, indexPath: IndexPath?, cell: UITableViewCell)
    func tapImage(cell: UITableViewCell)
    func removeImage(imageIndex: Int, cell: UITableViewCell)
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell)
    func pushToShipping(cell: UITableViewCell)
    func pushToCategory(cell: UITableViewCell)
    func pushAddressList(cell: UITableViewCell)
    func tapButton(actionType: ActionType)
    func updateHeightOfRow(_ cell: ItemDescCell, _ textView: UITextView)
    func openKeyword()
    func removeKeyword(array: [String])
    func pushToCondition(cell: UITableViewCell)
}


class ItemNameCell: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var lblTextCount: UILabel!
    @IBOutlet weak var imgViewCheck: UIImageView!
    var indexPath: IndexPath?
    weak var delegate: AddItemProtocol?
    @IBOutlet weak var txtItemName: SMFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.txtItemName.delegate = self
    }
    
    var textCount: Int = Constant.itemNameCount {
        didSet {
            if textCount == Constant.itemNameCount {
                self.lblTextCount.isHidden = true
            } else {
                self.lblTextCount.isHidden = false
                self.lblTextCount.text = "\(textCount)"
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        
        if let placeHolder = data[Constant.keys.kTitle] as? String {
            self.txtItemName.placeholder = placeHolder            
        }
        
        if let text = data[Constant.keys.kValue] as? String {
            self.txtItemName.text = text
             textCount = Constant.itemNameCount - text.utf8.count
        }
    }
    
}

extension ItemNameCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            self.imgViewCheck.isHidden = false
        } else {
            self.imgViewCheck.isHidden = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text), let delegate = self.delegate {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            if finalText.utf8.count > Constant.itemNameCount {
                return false
            }
            delegate.updateText(text: finalText, indexPath: indexPath, cell: self)
            textCount = Constant.itemNameCount - finalText.utf8.count
            if textCount == 0 {
                return false
            }
        }
        return true
    }
}
