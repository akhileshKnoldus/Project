//
//  UIView+Addition.swift
//  TheDon
//
//  Created by Sourabh on 20/02/18.
//  Copyright © 2018 Ashish Chauhan. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: - Properties
public extension UIView {
    
    public func initializeFromNib(nibNamed: String) {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(view)
        }
    }
    
    public func initializeFromNibAndGetView(nibNamed: String)-> UIView?
    {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibNamed, bundle: bundle)
        if let view = nib.instantiate(withOwner:nil, options: nil).first as? UIView {
            view.frame = bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            return view
        }
        
        return nil
    }
    
    
    
    
    public func roundCorners(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    public func addShadow(_ shadowRadius: CGFloat = 5.0, shadowOpacity: Float = 0.2) {
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
    
    public func addShadow(ofColor color: UIColor = UIColor.black,radius: CGFloat = 3,
                          offset: CGSize = CGSize.zero,
                          opacity: Float = 0.5)
    {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
        self.clipsToBounds = false
    }
    
    
    public func makeLayer( color: UIColor, boarderWidth: CGFloat, round:CGFloat) -> Void {
        self.layer.borderWidth = boarderWidth;
        self.layer.cornerRadius = round;
        self.layer.masksToBounds =  true;
        self.layer.borderColor = color.cgColor
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
     
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
        
    }
    
    func animation(view:UIView)
    {
        view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .allowUserInteraction , animations: {
            view.transform = CGAffineTransform.identity
        }) { (fininsh) in
            
        }
    }
    
    func animateView()
    {
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
        }) { (true) in
            UIView.animate(withDuration: 1.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.layoutIfNeeded()
            }) { (true) in
            }
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.35, animations: {
            //            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { (finished : Bool) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
}

public let kShapeDashed : String = "kShapeDashed"

extension UIView {
    
    func removeDashedBorder(_ view: UIView) {
        view.layer.sublayers?.forEach {
            if kShapeDashed == $0.name {
                $0.removeFromSuperlayer()
            }
        }
    }
    
    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [2,2], strokeColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil {
            fWidth = self.frame.width
        }
        
        if fHeight == nil {
            fHeight = self.frame.height
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = kShapeDashed
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

@IBDesignable class DottedVertical: UIView {
    
    @IBInspectable var dotColor: UIColor = UIColor.black
    @IBInspectable var lowerHalfOnly: Bool = false
    
    override func draw(_ rect: CGRect) {
        
        // say you want 8 dots, with perfect fenceposting:
        let totalCount = 15 + 15 - 1
        let fullHeight = bounds.size.height
        let width = bounds.size.width
        let itemLength = fullHeight / CGFloat(totalCount)
        
        let path = UIBezierPath()
        
        let beginFromTop = CGFloat(0.0)
        let top = CGPoint(x: width/2, y: beginFromTop)
        let bottom = CGPoint(x: width/2, y: fullHeight)
        
        path.move(to: top)
        path.addLine(to: bottom)
        
        path.lineWidth = width
        
        let dashes: [CGFloat] = [itemLength, itemLength]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        
        // for ROUNDED dots, simply change to....
        //let dashes: [CGFloat] = [0.0, itemLength * 2.0]
        //path.lineCapStyle = CGLineCap.round
        
        dotColor.setStroke()
        path.stroke()
    }
}
