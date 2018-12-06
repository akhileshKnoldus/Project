//
//  DropDownTable.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 30/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class DropDownTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var array = [[String: Any]]()
    var arrayAll = [[String: Any]]()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var didSelectRow: ((_ tag: String) -> Void)?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        self.separatorStyle = .none
        self.separatorColor = .clear
        self.delegate = self
        self.dataSource = self
    }
    
    public func configureList(array: [[String: Any]]) {
        self.array.removeAll()
        self.arrayAll.removeAll()
        self.array.append(contentsOf: array)
        self.arrayAll.append(contentsOf: array)
        self.separatorStyle = .none
        self.separatorColor = .clear
    }
    
    func updateSearch(_ text: String) {
        
        if text.isEmpty {
            self.array.removeAll()
            self.array.append(contentsOf: self.arrayAll)
            self.reloadData()
            return
        }
        //if text.utf8.count >= 2 {
            var filterarray = [[String: Any]]()
            for tag in self.arrayAll {
                if let tagStr = tag["tag"] as? String, tagStr.hasPrefix(text) {
                    filterarray.append(tag)
                }
            }
            //let filterArray = self.arrayAll.filter { $0["tag"].contains(text) }
            self.array.removeAll()
            self.array.append(contentsOf: filterarray)
            self.reloadData()
        //}
    }
    
    func updateFrame(frame: CGRect) {
        self.frame = frame
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CELL")
        }
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_15)
        if let text = array[indexPath.row]["tag"] as? String {
            cell?.textLabel?.text = text
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let completion = self.didSelectRow, let text = array[indexPath.row]["tag"] as? String {
            completion(text)
        }
    }
}

class DropDownView: UIView {
    
    let dropDownTable = DropDownTable(frame: .zero, style: .plain)
    let cropssButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        
    }
    
    func setupView() {
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        if !dropDownTable.isDescendant(of: self) {
            self.addSubview(dropDownTable)
            self.addCrossButton()
            self.updateTableFrame()
        }
        
    }
    
    func updateTableFrame() {
        var bounds = self.bounds
        bounds.origin.x = 10
        bounds.origin.y = 10
        bounds.size.height -= 20
        bounds.size.width -= 20
        dropDownTable.frame = bounds
        cropssButton.frame = CGRect(x: self.bounds.size.width - 35, y: 5, width: 30, height: 30)
    }
    
    func addCrossButton() {
        cropssButton.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        cropssButton.addTarget(self, action: #selector(removeView), for: .touchUpInside)
        self.addSubview(cropssButton)
    }
    
    @objc func removeView() {
        if let completion = self.dropDownTable.didSelectRow {
            completion("")
        }
    }
    
}
