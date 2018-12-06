//
//  DetailProductAnswer.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 28/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DetailProductAnswer: BaseTableViewCell, NibLoadableView, ReusableView {

    @IBOutlet weak var btnShowMore: UIButton!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
    @IBOutlet weak var lblTimeAgo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Threads.performTaskAfterDealy(0.2) {
            self.imgViewUser.roundCorners(24.0)
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(question: Question) {
        
        if let profilePic = question.profilePic {
            self.imgViewUser.setImage(urlStr: profilePic, placeHolderImage: #imageLiteral(resourceName: "user_placeholder"))
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
    }
    
}
