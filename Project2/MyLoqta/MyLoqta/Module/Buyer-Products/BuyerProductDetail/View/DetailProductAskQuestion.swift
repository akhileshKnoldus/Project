//
//  DetailProductAskQuestion.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

protocol DetailProductProtocol: class {
    func askQuestion(question: String, cell: DetailProductAskQuestion)
}

class DetailProductAskQuestion: BaseTableViewCell, NibLoadableView, ReusableView {

    weak var delegate: DetailProductProtocol?
    @IBOutlet weak var txtFieldQuestion: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.txtFieldQuestion.autocorrectionType = .no
        self.txtFieldQuestion.delegate = self
        self.txtFieldQuestion.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(doneTapped), target: self)
        self.btnSend.isHidden = true
        self.txtFieldQuestion.text = ""
    }
    
    @objc func doneTapped() {
        self.txtFieldQuestion.resignFirstResponder()
    }
    
    @IBAction func tapSend(_ sender: Any) {
        
        if let question = self.txtFieldQuestion.text, !question.isEmpty,let delegate = self.delegate {
            delegate.askQuestion(question: question, cell: self)
            self.txtFieldQuestion.resignFirstResponder()
        }
    }
}

extension DetailProductAskQuestion: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.btnSend.isHidden = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
