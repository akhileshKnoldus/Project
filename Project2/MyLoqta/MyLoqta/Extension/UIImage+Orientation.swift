//
//  UIImage+Orientation.swift
//  OneNation
//
//  Created by TA Software on 22/12/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func manageOrientation(maxResolution : CGFloat) -> UIImage? {
        let width: CGFloat = CGFloat(self.cgImage!.width);
        let height: CGFloat = CGFloat(self.cgImage!.height);
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        var bounds = rect
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        var transform = CGAffineTransform.identity
        let orient = self.imageOrientation
        let size =  CGSize(width:CGFloat(self.cgImage!.width) , height: CGFloat(self.cgImage!.height))
        let imageSize = size
        switch(self.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: .pi);
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * .pi / 2.0);
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * .pi / 2.0);
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: .pi / 2.0);
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: .pi / 2.0);
        }
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        if orient == .right || orient == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio);
            context!.translateBy(x: -height, y: 0);
        } else {
            
            context!.scaleBy(x: scaleRatio, y: -scaleRatio);
            context!.translateBy(x: 0, y: -height);
        }
        context!.concatenate(transform);
        let rect2 = CGRect(x: 0, y: 0, width: width, height: height)
        context!.draw(self.cgImage!, in: rect2)
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return imageCopy;
    }
    
    func manageOrientation(maxResolution : CGFloat, quality: JPEGQuality) -> UIImage? {
        let width: CGFloat = CGFloat(self.cgImage!.width);
        let height: CGFloat = CGFloat(self.cgImage!.height);
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        var bounds = rect
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        var transform = CGAffineTransform.identity
        let orient = self.imageOrientation
        let size =  CGSize(width:CGFloat(self.cgImage!.width) , height: CGFloat(self.cgImage!.height))
        let imageSize = size
        switch(self.imageOrientation) {
        case .up :
            transform = CGAffineTransform.identity
        case .upMirrored :
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
        case .down :
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height);
            transform = transform.rotated(by: .pi);
        case .downMirrored :
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height);
            transform = transform.scaledBy(x: 1.0, y: -1.0);
        case .left :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width);
            transform = transform.rotated(by: 3.0 * .pi / 2.0);
        case .leftMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width);
            transform = transform.scaledBy(x: -1.0, y: 1.0);
            transform = transform.rotated(by: 3.0 * .pi / 2.0);
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0);
            transform = transform.rotated(by: .pi / 2.0);
        case .rightMirrored :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
            transform = transform.rotated(by: .pi / 2.0);
        }
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        if orient == .right || orient == .left {
            context!.scaleBy(x: -scaleRatio, y: scaleRatio);
            context!.translateBy(x: -height, y: 0);
        } else {
            
            context!.scaleBy(x: scaleRatio, y: -scaleRatio);
            context!.translateBy(x: 0, y: -height);
        }
        context!.concatenate(transform);
        let rect2 = CGRect(x: 0, y: 0, width: width, height: height)
        context!.draw(self.cgImage!, in: rect2)
        guard let imageCopy = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        let imageData = UIImageJPEGRepresentation(imageCopy, quality.rawValue)
        UIGraphicsEndImageContext();
        if let data = imageData, let image = UIImage(data: data) {
            return image
        }
        return nil
    }
    
    func resizeImageWith(width: CGFloat, height: CGFloat? = nil) -> UIImage? {
        var imageView: UIImageView!
        if let safeHeight = height {
            imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: safeHeight)))
        } else {
            imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
