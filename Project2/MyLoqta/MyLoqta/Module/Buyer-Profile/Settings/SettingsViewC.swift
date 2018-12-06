//
//  SettingsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SettingsViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tblViewSettings: UITableView!
    
    //MARK: - Variables
    var viewModel: SettingsVModeling?
    var arrayData = [[SettingData]]()

    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.registerCell()
        if let array = self.viewModel?.getDataSource() {
            self.arrayData.append(contentsOf: array)
        }
        self.setupTableStyle()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SettingsVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewSettings.separatorStyle = .none
        self.tblViewSettings.dataSource = self
        self.tblViewSettings.delegate = self
    }
    
    private func registerCell() {
        self.tblViewSettings.register(SettingsCell.self)
    }
    
    fileprivate func pushToEditProfile() {
        if let editProfileVC = DIConfigurator.sharedInst().getEditProfile() {
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    
    fileprivate func pushToAddressList() {
        if let addressListVC = DIConfigurator.sharedInst().getAddressList() {
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }
    }
    
    fileprivate func pushToNotificationsView() {
        if let notificationSettingsVC = DIConfigurator.sharedInst().getNotificationSettingsViewC() {
            self.navigationController?.pushViewController(notificationSettingsVC, animated: true)
        }
    }
    
    fileprivate func pushToHelpView() {
        if let helpVC = DIConfigurator.sharedInst().getHelpViewC() {
            helpVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(helpVC, animated: true)
        }
    }
    
    fileprivate func pushToFAQView() {
        if let faqVC = DIConfigurator.sharedInst().getSettingsWebViewC() {
            faqVC.urlToLoad = Constant.faqUrl
            faqVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(faqVC, animated: true)
        }
    }
    
    fileprivate func pushToAboutUsView() {
        if let aboutUsVC = DIConfigurator.sharedInst().getSettingsWebViewC() {
            aboutUsVC.urlToLoad = Constant.aboutUsUrl
            aboutUsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
        }
    }
    
    fileprivate func pushToPrivacyPolicyView() {
        if let privacyVC = DIConfigurator.sharedInst().getSettingsWebViewC() {
            privacyVC.urlToLoad = Constant.privacyPolicyUrl
            privacyVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(privacyVC, animated: true)
        }
    }
    
    fileprivate func moveToReviewsViewC() {
        if let reviewsViewC = DIConfigurator.sharedInst().getBuyerReviewsViewC() {
            self.navigationController?.pushViewController(reviewsViewC, animated: true)
        }
    }
    
    
    fileprivate func logut() {
        Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Are you sure, you want to logout?".localize(), actionTitle: "Ok".localize(), showCancel: true, action: { (action) in
            
            self.viewModel?.requestToLogout(completion: { (success) in
                UIApplication.shared.applicationIconBadgeNumber = 0
                UserSession.sharedSession.clearDataOfUserSession()
                AppDelegate.delegate.showHome()
            })
        })
    }
    
    //MARK: - IBActions
    @IBAction func tapCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - TableViewDelegatesAndDataSource
extension SettingsViewC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? arrayData[0].count : arrayData[1].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.arrayData[indexPath.section][indexPath.row]
        cell.configureData(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let lblTitle = UILabel(frame: CGRect(x: 10, y: 15, width: 100, height: 15))
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_13)
        lblTitle.textColor = UIColor.colorWithRGBA(redC: 166.0, greenC: 166.0, blueC: 166.0, alfa: 1.0)
        lblTitle.text = section == 0 ? "Account".localize() : "More".localize()
        view.addSubview(lblTitle)
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: self.pushToEditProfile()
            case 1: self.moveToReviewsViewC()
            case 2: self.pushToAddressList()
            case 3: self.pushToNotificationsView()
            default: break
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: self.pushToHelpView()
            case 1: self.pushToFAQView()
            case 2: self.pushToAboutUsView()
            case 3: self.pushToPrivacyPolicyView()
            case 4: self.logut()
            default: break
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
}
