//
//  OrderTrackingCell.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 09/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderTrackingCell: BaseTableViewCell, NibLoadableView, ReusableView { 
    @IBOutlet weak var lblStatus: AVLabel!
    @IBOutlet weak var viewTrack: UIView!
    
    @IBOutlet weak var lineFirst: UIView!
    @IBOutlet weak var lineSecond: UIView!
    @IBOutlet weak var lineThird: UIView!
    @IBOutlet weak var lineFourth: UIView!
    
    @IBOutlet weak var circleFith: UIView!
    @IBOutlet weak var circleFourth: UIView!
    @IBOutlet weak var circleThird: UIView!
    @IBOutlet weak var circleSecond: UIView!
    @IBOutlet weak var circleFirst: UIView!
    @IBOutlet weak var lblDetail: AVLabel!
    
    var arrayViews = [UIView]()
    var arrayLine = [UIView]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        arrayViews.append(contentsOf: [circleFirst, circleSecond, circleThird, circleFourth, circleFith])
        arrayLine.append(contentsOf: [lineFirst, lineSecond, lineThird, lineFourth])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(data: [String: Any]) {
        if let orderStatus = data["orderStatus"] as? OrderStatus {
            let statusValue = Helper.getOrderStatsText(orderStatus: orderStatus)
            self.lblStatus.text = statusValue.title
            self.updateProgressStatus(orderStatus: orderStatus)
        }
        
        
        /*
       // var arrayCircle = [circleFirst, circleSecond, circleThird, circleFourth, circleFith]
        self.selectedColorOfCircle(view: circleFirst)
        self.selectedColorOfCircle(view: circleSecond)
        self.selectedColorOfCircle(view: circleThird)
        self.grayColorOfCircle(view: circleFourth)
        self.grayColorOfCircle(view: circleFith)
        
        self.selectedColorOfLine(view: lineFirst)
        self.selectedColorOfLine(view: lineSecond)
        self.grayColorOfLine(view: lineThird)
        self.grayColorOfLine(view: lineFourth)*/
        
    }
    
    func updateProgressStatus(orderStatus: OrderStatus)  {
        
        for view in self.arrayViews {
            self.grayColorOfCircle(view: view)
        }
        for view in self.arrayLine {
            self.grayColorOfLine(view: view)
        }
        switch orderStatus {
        case .newOrder: self.selectedColorOfCircle(view: self.arrayViews[0])
        case .waitingForPickup: self.updatedWithIndex(index: 1)
        case .onTheWay: self.updatedWithIndex(index: 2)
        case .delivered: self.updatedWithIndex(index: 3)
        case .completed: self.updatedWithIndex(index: 4)
        default: break
        }
    }
    
    func updatedWithIndex(index: Int)  {
        for i in 0...index {
            self.selectedColorOfCircle(view: self.arrayViews[i])
            let lineIndex = i - 1
            if lineIndex >= 0 {
                self.selectedColorOfLine(view: self.arrayLine[lineIndex])
            }
        }
    }
    
    func selectedColorOfCircle(view: UIView) {
        view.backgroundColor = UIColor.appOrangeColor
        view.roundCorners(5.0)
        view.makeLayer(color: UIColor.appOrangeColor, boarderWidth: 2.0, round: 5.0)
    }
    
    func selectedColorOfLine(view: UIView) {
        view.backgroundColor = UIColor.appOrangeColor
    }
    
    func grayColorOfCircle(view: UIView) {
        let grayColor = UIColor.colorWithRGBA(redC: 225, greenC: 231, blueC: 236, alfa: 1.0)
        view.makeLayer(color: grayColor, boarderWidth: 2.0, round: 5.0)
        
    }
    func grayColorOfLine(view: UIView) {
        let grayColor = UIColor.colorWithRGBA(redC: 225, greenC: 231, blueC: 236, alfa: 1.0)
        view.backgroundColor = grayColor
    }
    
    
    
}
