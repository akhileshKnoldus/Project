//
//  ReferralViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/20/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ReferralViewC: BaseViewC {

    //MARK: - IBOutlets
    
    @IBOutlet weak var headerView: AVView!
    @IBOutlet weak var tblViewReferral: UITableView!

    //MARK: - Variables
    var viewModel: ReferralVModeling?
    
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
    
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        Threads.performTaskAfterDealy(0.05) {
            self.headerView.drawGradientWithRGB(startColor: UIColor.lightPurpleGradientColor, endColor: UIColor.darkPurpleGradientColor)
        }
        self.tblViewReferral.reloadData()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ReferralVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewReferral.delegate = self
        self.tblViewReferral.dataSource = self
        self.tblViewReferral.allowsSelection = false
        self.tblViewReferral.separatorStyle = .none
    }
    
    private func registerCell() {
        self.tblViewReferral.register(ReferralImageCell.self)
        self.tblViewReferral.register(ReferralDetailCell.self)
        self.tblViewReferral.register(WithdrawButtonCell.self)
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
