//
//  ProductQuestionCell.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import UITextView_Placeholder

protocol DismissKeyboardDelegates: class {
    func didPerformActionOnDismissingKeyboard()
}

class ProductQuestionCell: BaseTableViewCell, NibLoadableView, ReusableView {

    //MARK: - IBOutlets
    @IBOutlet weak var imgViewBuyer: UIImageView!
    @IBOutlet weak var lblBuyerName: UILabel!
    @IBOutlet weak var lblBuyerQuestion: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var txtViewReply: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnReply: UIButton!
    
    weak var delegate: ProductDetailCellDelegate?
    weak var weakDelegate: DismissKeyboardDelegates?
    var question: Question?
    
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
        self.imgViewBuyer.roundCorners(self.imgViewBuyer.frame.size.width/2)
        self.btnSend.setTitle("Send".localize(), for: .normal)
        self.btnReply.setTitle("Reply to question".localize(), for: .normal)
        self.replyView.isHidden = true
        self.questionView.isHidden = false
        self.txtViewReply.placeholder = "Reply to question".localize()
        self.txtViewReply.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
        
    }
    
    func configureCell(question: Question) {
        
        self.question = question
        if let name = question.userName {
            self.lblBuyerName.text = name
        }
        
        if let question = question.question {
            self.lblBuyerQuestion.text = question
        }
        
        if let profilePic = question.profilePic {
            self.imgViewBuyer.setImage(urlStr: profilePic, placeHolderImage: #imageLiteral(resourceName: "user_placeholder"))
        }
        
        if let questionTime = question.createdAt {
            self.lblTime.text = Date.timeSince(questionTime)
        }
        
        /*var questionId : Int?
        var question : String?
        var userId : Int?
        var userName : String?
        var questionTime : String?
        var profilePic : String?
        var reply : [Reply]?*/
    }
    
    //MARK: - IBActions
    @IBAction func tapReply(_ sender: UIButton) {
        self.replyView.isHidden = false
        self.questionView.isHidden = true
        self.txtViewReply.becomeFirstResponder()
    }
    
    @IBAction func tapSend(_ sender: UIButton) {
        
        self.replyView.isHidden = true
        self.questionView.isHidden = false
        if let text = self.txtViewReply.text, !text.isEmpty, let delegate = self.delegate, let question = self.question {
            self.txtViewReply.resignFirstResponder()
            delegate.replyToAnswer(text: text, question: question)
            self.txtViewReply.text = ""
        }
    }
    
    //MARK: - Selector Methods
    @objc func tapDone() {
        if self.weakDelegate != nil {
            self.weakDelegate?.didPerformActionOnDismissingKeyboard()
        }
    }
}
