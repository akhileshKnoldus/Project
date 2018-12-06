//
//  UICollectionView+Additions.swift
//  Ashish Chauhan
//
//  Created by Ashish Chauhan on 10/31/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func scrollToFirst() {
        if self.contentSize.width > self.frame.width {
            self.contentOffset = CGPoint(x: (self.contentSize.width) - self.frame.width, y: 0)
        }
    }
    
    func registerNib(nib nibName:String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func register<T:UICollectionViewCell>(_: T.Type) where T: ReusableView, T: NibLoadableView {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        self.register(nib, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T:UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
    
    func registerReusableSupplementaryView<T: ReusableView>(elementKind: String, _: T.Type) {
        self.register(T.self, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(elementKind: String, indexPath: IndexPath) -> T where T: ReusableView, T: NibLoadableView {
        if let view = self.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T {
            return view
        } else {
            return UIView() as! T
        }
    }
    
    func getIndexPathFor(view: UIView) -> IndexPath? {
        
        let point = self.convert(view.bounds.origin, from: view)
        let indexPath = self.indexPathForItem(at: point)
        return indexPath
    }
}


