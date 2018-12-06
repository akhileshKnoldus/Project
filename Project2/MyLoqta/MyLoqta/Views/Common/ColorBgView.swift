//
//  ColorBgView.swift
//  AppVenture
//
//  Created by Ashish Chauhan on 03/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import Foundation

class ColorBgView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    /*
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.initializeColor()
    }*/
    
    let yellowTag = 100
    let blueTag = 101
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeColor()
    }
    
    private func initializeColor() {
        
        self.backgroundColor = UIColor.appRedColor
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 265.5 * Constant.wdRation, height: 500.3 * Constant.htRation))
        blueView.backgroundColor = UIColor.appBlueColor
        blueView.tag = blueTag
        
        let yellowWidth = 202.8 * Constant.wdRation
        let yellowHeight = 359.1 * Constant.htRation
        let yellowView = UIView(frame: CGRect(x: Constant.screenWidth - yellowWidth, y: Constant.screenHeight - yellowHeight, width: yellowWidth, height: yellowHeight))
        yellowView.tag = yellowTag
        yellowView.backgroundColor = UIColor.appYellowColor
        self.addSubview(blueView)
        self.addSubview(yellowView)
        
    }
    
    func updateBackgroudForSeller() {
        if let blueView = self.viewWithTag(blueTag), let yellowView = self.viewWithTag(yellowTag) {
            //let blueOrining = blueView.frame.origin
            let yellowOrinig = CGPoint(x: 0, y: 0)
            
            let blueWd = 265.5 * Constant.wdRation
            let blueHt = 500.3 * Constant.htRation
            
            blueView.frame.origin = CGPoint(x: Constant.screenWidth - blueWd, y: Constant.screenHeight - blueHt)
            yellowView.frame.origin = yellowOrinig
        }
    }
}
