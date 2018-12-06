//
//  DetailProductQuestion.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DetailProductQuestion: BaseTableViewCell, NibLoadableView, ReusableView {
    
    
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUserImage: UIImageView!
    @IBOutlet weak var lblNoOfQuestion: UILabel!
    
    
    
    @IBOutlet weak var imgViewBlueCheck: UIImageView!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var lblReplyTimeAgo: UILabel!
    @IBOutlet weak var lblReplyTo: UILabel!
    @IBOutlet weak var lblStoreName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        Threads.performTaskAfterDealy(0.2) {
            self.lblUserImage.roundCorners(24.0)
        }
    }
    
    func configreCell(question: Question, indexPath: IndexPath, product: Product? = nil) {
        
        if indexPath.row == 0, let producutDetail = product, let count = producutDetail.questionAnswersCount {
            lblNoOfQuestion.text = "Questions and Answers . \(count)"
        } else {
            lblNoOfQuestion.text = ""
        }
        
        if let profilePic = question.profilePic {
            self.lblUserImage.setImage(urlStr: profilePic, placeHolderImage: #imageLiteral(resourceName: "user_placeholder"))
        }
        if let name = question.userName {
            self.lblUserName.text = name
        }
        
        if let questionStr = question.question {
            self.lblQuestion.text = questionStr
        }
        
        if let questionTime = question.createdAt {
            self.lblTimeAgo.text = Date.timeSince(questionTime)
        }
        
        if let arrayReply = question.reply {
            if arrayReply.count > 0 {
            let reply = arrayReply[0]
            if let sellerName = reply.sellerName {
                self.lblStoreName.text = sellerName
            }
            
            if let text = self.lblUserName.text {
                let replyText = "replied to".localize()
                self.lblReplyTo.text = "\(replyText) \(text)"
            }
            
            if let replystr = reply.reply {
                self.lblReply.text = replystr
            }
            
            if let replyTime = reply.createdAt {
                self.lblReplyTimeAgo.text = Date.timeSince(replyTime)
            }
            }
        }
    }
}
