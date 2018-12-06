//
//  PopUpSearchView.swift
//  OneNation
//
//  Created by Ashish Chauhan on 26/12/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import UIKit

class PopUpSearchView: UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let cellHeight = CGFloat(40)
    let LeftMargin = 40
    let TopMargin = 100
    let Radius : Float = 4.0
    var tblView : UITableView!
    var title = ""
    var arrayList = [[String :AnyObject]]()
    var arrayAll = [[String :AnyObject]]()
    var key = ""
    var completionBlock : ((Any) -> Void)!
    var searchBar: UISearchBar?
    
    //MARK: Initialization
    func initWithTitle(title: String, array : AnyObject, keyValue: String) -> AnyObject {
        var rect = UIScreen.main.bounds
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            rect.size = CGSize(width: rect.size.height, height: rect.size.width)
        }
        
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        
        self.title = title
        if let list = array as? [[String : AnyObject]] {
            self.arrayList = list.map { $0 }
            self.arrayAll = list.map { $0 }
        }
        self.key = keyValue
        let screenSize = UIScreen.main.bounds.size
        let screenHt = screenSize.height
        var htcount = 0
        switch screenHt {
        case 480:
            htcount = 6
        case 568:
            htcount = 8
        case 667:
            htcount = 10
        default:
            htcount = 12
        }
        var ht = 0
        if self.arrayList.count >= htcount {
            ht = htcount * 44
        } else {
            ht = self.arrayList.count * 44
        }
        let screenWidth = UIScreen.main.bounds.size.width
        ht += 45
        self.tblView = UITableView(frame: CGRect(x: LeftMargin, y: TopMargin, width: (Int(screenWidth) - (2 * LeftMargin)), height: ht))
        self.tblView?.delegate = self
        self.tblView?.dataSource = self
        self.tblView?.tableFooterView = UIView.init(frame: CGRect.zero)
        
        let sublayer = CALayer()
        sublayer.frame = CGRect(x: (self.tblView?.frame.origin.x)!, y: (self.tblView?.frame.origin.y)!, width: (self.tblView?.frame.size.width)!, height: self.frame.size.height)
        self.layer.addSublayer(sublayer)
        self.layer.addSublayer((self.tblView?.layer)!)
        self.addSubview(self.tblView!)
        //self.layer.shadowOffset = CGSize(width: 5, height: 5)
        //self.layer.shadowColor = UIColor.gray.cgColor
        //self.layer.shadowOpacity = 1.0
        //self.layer.shadowRadius = 4
        self.backgroundColor = UIColor.colorWithAlpha(color: 0.0, alfa: 0.8)
        return self
    }
    
    func initWithTitle(title : String, arrayList : [[String : AnyObject]], keyValue : String, handler: ((Any) -> Void)?)
    {
        if self === self.initWithTitle(title: title, array: arrayList as AnyObject, keyValue: keyValue) {
            completionBlock = handler!
        }
    }
    
    //MARK: Private Methods
    func fadeIn() {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        UIView.animate(withDuration: 0.35) {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func fadeOutView() {
        UIView.animate(withDuration: 0.2, animations: {
        }) { (finished : Bool) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func orientationDidChange(note : Notification) {
        let rect = UIScreen.main.bounds
        self.frame = rect
        self.setNeedsDisplay()
    }
    
    //MARK: -- Instance method
    func showWithAnimated(animated : Bool) {
        self.showWithView(view: UIApplication.shared.keyWindow!, animated: animated)
    }
    
    func showWithView(view: UIView, animated : Bool) {
        let rect = view.frame
        self.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
        view.addSubview(self)
        if animated {
            self.fadeIn()
        }
    }
    
    //MARK: -- UITableViewDelegate and DataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: (self.tblView?.frame.size.width)!, height: 50))
        view.backgroundColor = .white
        let button = AVButton(frame: CGRect(x: 16, y: 5, width: (tableView.frame.size.width - 32), height: 40))
        button.conrnerRadius = CGFloat(8)
        button.setTitle("Done".localize(), for: .normal)
        view.addSubview(<#T##view: UIView##UIView#>)
        
        return view
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView.init(frame: CGRect(x: 0, y: 0, width: (self.tblView?.frame.size.width)!, height: 50))
        view.backgroundColor = UIColor.appOrangeColor
        //if section == 0 {
        let lblTitle = UILabel(frame: CGRect(x: 40, y: 10, width: (tableView.frame.size.width - 80), height: 30))
        lblTitle.text = self.title
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Medium, size: FontSize.size_17)
        lblTitle.textColor = UIColor.white
        lblTitle.textAlignment = .center
        view.addSubview(lblTitle)
        
        let btnCross = UIButton(type: .custom)
        btnCross.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        btnCross.setImage(#imageLiteral(resourceName: "cross_white"), for: .normal)
        btnCross.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        view.addSubview(btnCross)
        
        /*} else {
            if searchBar == nil {
                searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: 40))
                searchBar?.backgroundColor = .white
                searchBar?.delegate = self
            }
            view.addSubview(searchBar!)
        }*/
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if section
        return self.arrayList.count
        //return section == 0 ? 0 :  self.arrayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cellIndentity = "cell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        if var text = self.arrayList[indexPath.row][key] as? String {
            
            if let code = self.arrayList[indexPath.row]["country_dialing_code"] as? String {
                text += "   " + code
            }
            cell.textLabel?.text = text
            
        } else {
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.completionBlock != nil) {
            let dic = self.arrayList[indexPath.row]
            self.completionBlock(dic)
        }
        self.fadeOutView()
    }
    
    //MARK: -- Another Actions
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.closeAction()
    }
    
    @objc func closeAction() {
        self.fadeOutView()
    }
    
    @objc func saveAction() {
        if (self.completionBlock != nil) {
            self.completionBlock(arrayList)
        }
        self.fadeOutView()
    }
    
    //MARK:- Search Bar delegates
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        self.arrayList.removeAll()
        if let text = searchBar.text, !text.isEmpty {
            let predicate = NSPredicate(format: "\(self.key) CONTAINS[c] %@", text)
             let array = self.arrayAll.filter({ predicate.evaluate(with: $0) })
            if array.count > 0 {
                self.arrayList = array
            }
            
        } else {
            self.arrayList = self.arrayAll
        }
        self.tblView.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (searchBar.textInputMode?.primaryLanguage == "emoji") || !((searchBar.textInputMode?.primaryLanguage) != nil) {
            return false
        }
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.arrayList.removeAll()
        self.arrayList = self.arrayAll
        self.tblView.reloadData()
    }
}
