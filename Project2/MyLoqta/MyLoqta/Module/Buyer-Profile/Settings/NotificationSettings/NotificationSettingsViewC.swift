//
//  NotificationSettingsViewC.swift
//  MyLoqta
//
//  Created by Kirti on 9/7/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class NotificationSettingsViewC: BaseViewC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblViewNotifications: UITableView!
    
    //MARK: - Variables
    var viewModel: NotificationSettingsVModeling?
    var arrayDataSource = [[NotificationSettingData]]()

    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    
    private func setUp(){
        self.recheckVM()
        self.registerCell()
        if let array = self.viewModel?.getDataSourceForNotifications() {
            self.arrayDataSource.append(contentsOf: array)
        }
    }
    
    private func registerCell() {
        self.tblViewNotifications.register(NotificationViewTableCell.self)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = NotificationSettingsVM()
        }
    }
    
    //MARK:- IBAction Methods
    @IBAction func tapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- UITableView Delegates & Datasource Methods
extension NotificationSettingsViewC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return arrayDataSource[0].count
        case 1: return arrayDataSource[1].count
        case 2: return arrayDataSource[2].count
        default: return arrayDataSource[3].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotificationViewTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.arrayDataSource[indexPath.section][indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let lblTitle = UILabel(frame: CGRect(x: 16, y: 20, width: 100, height: 15))
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_13)
        lblTitle.textColor = UIColor.colorWithRGBA(redC: 166.0, greenC: 166.0, blueC: 166.0, alfa: 1.0)
        var title = ""
        switch section {
        case 1: title = "Buying".localize()
        case 2: title = "Selling".localize()
        default: title = "General".localize()
        }
        lblTitle.text = title
        
        let lblSeparator = UILabel(frame: CGRect(x: 16, y: 43, width: Constant.screenWidth-32, height: 1))
        lblSeparator.backgroundColor = UIColor.colorWithRGBA(redC: 243.0, greenC: 243.0, blueC: 243.0, alfa: 1.0)
        lblSeparator.text = ""
        view.addSubview(lblSeparator)
        view.addSubview(lblTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44.0
    }
}
