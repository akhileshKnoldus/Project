//
//  BuyerAcceptOrderViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 9/18/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BuyerAcceptOrderViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var tblViewOrder: UITableView!
    @IBOutlet weak var btnAccept: AVButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var btnNotReceive: UIButton!
    
    //MARK: - Variables
    var viewModel: BuyerAcceptOrderVModeling?
    
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
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.setupTableStyle()
        self.btnReject.roundCorners(Constant.btnCornerRadius)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = BuyerAcceptOrderVM()
        }
    }
    
    private func setupTableStyle() {
        self.registerCell()
        self.tblViewOrder.tableHeaderView = self.viewHeader
        self.tblViewOrder.dataSource = self
        self.tblViewOrder.delegate = self
        self.tblViewOrder.allowsSelection = false
        self.tblViewOrder.separatorStyle = .none
    }
    
    private func registerCell() {
        self.tblViewOrder.register(OrderDetailCell.self)
        self.tblViewOrder.register(ItemDescriptionCell.self)
        self.tblViewOrder.register(SellerCell.self)
        self.tblViewOrder.register(OrderTotalPriceCell.self)
    }
    
    //MARK: - Public Methods
    
    
    //MARK: - IBActions
    
    @IBAction func tapAcceptOrder(_ sender: UIButton) {
        
    }
    
    @IBAction func tapRejectOrder(_ sender: UIButton) {
        
    }
    
    @IBAction func tapNotReceive(_ sender: UIButton) {
        
    }
}
