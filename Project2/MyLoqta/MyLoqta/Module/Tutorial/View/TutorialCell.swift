//
//  TutorialCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 05/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Lottie

class TutorialCell: BaseCollectionViewCell, ReusableView, NibLoadableView {

    @IBOutlet weak var btnGetStarted: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var pagControl: UIPageControl!
    @IBOutlet weak var viewAnimation: UIView! // 15 70 345 384
    @IBOutlet weak var lblDescription: AVLabel!
    @IBOutlet weak var lblTitle: AVLabel!
    var tutorialType: TutorialType = .explore
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(data: TutorialDesc) {
        
        self.btnGetStarted.roundCorners(cornerRadius)
        self.btnGetStarted.setTitle(NSLocalizedString("Get Started", comment: ""), for: .normal)
        self.viewAnimation.subviews.forEach { $0.removeFromSuperview() }
        self.lblTitle.text = data.title
        self.lblDescription.text = data.description
        self.loadAnimation(data: data)
        self.tutorialType = data.tutorialType
        if data.tutorialType == .delivery {
            self.btnGetStarted.setTitleColor(data.bgColor, for: .normal)
            self.pagControl.isHidden = true
            self.btnSkip.isHidden = true
            self.btnGetStarted.isHidden = false
        } else {
            self.pagControl.currentPage = data.tutorialType.rawValue
            self.pagControl.isHidden = false
            self.btnSkip.isHidden = false
            self.btnGetStarted.isHidden = true
        }
        
    }
    
    func loadAnimation(data: TutorialDesc)  {
        var animationName = ""
        switch data.tutorialType {
        case .explore: animationName = "start"
        case .seller: animationName = "start_2_1"
        case .delivery: animationName = "start_3"
        }
        //self.viewAnimation.backgroundColor = data.bgColor
        self.viewAnimation.backgroundColor = UIColor.clear
        self.backgroundColor = data.bgColor
        Threads.performTaskAfterDealy(0.2) {
            self.playAnimation(name: animationName)
        }
    }
    
    func playAnimation(name: String) {
        self.viewAnimation.subviews.forEach { $0.removeFromSuperview() }
        let animationView = LOTAnimationView(name: name)
        animationView.frame =  self.viewAnimation.bounds
        animationView.animationSpeed = CGFloat(0.75)
        animationView.contentMode = .scaleAspectFit
        self.viewAnimation.addSubview(animationView)
        animationView.play{ [weak self] (finished) in
            guard let strongSelf = self else { return }
            if finished {
                if name == "start_2_1"  {
                    strongSelf.playAnimation(name: "end_2_2")
                } else {
                    if strongSelf.tutorialType == .seller {
                        strongSelf.playAnimation(name: "start_2_1")
                    } else {
                        strongSelf.playAnimation(name: name)
                    }
                }
            }
        }
    }
}
