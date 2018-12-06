//
//  OrderCompletedViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 8/11/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class OrderCompletedViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var btnContinueShopping: AVButton!
    @IBOutlet weak var btnMyOrders: UIButton!
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:- Private Methods
    func moveToMyOrdersListView() {
        if let buyerOrderListViewC = DIConfigurator.sharedInst().getBuyerOrderListViewC() {
            buyerOrderListViewC.isFromMyOrders = true
            self.navigationController?.pushViewController(buyerOrderListViewC, animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapCross(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        UserSession.sharedSession.removeGuestItems()
        AppDelegate.delegate.showHome()
    }
    
    @IBAction func tapContinueShopping(_ sender: UIButton) {
        UserSession.sharedSession.removeGuestItems()
        AppDelegate.delegate.showHome()
    }
    
    @IBAction func tapMyOrders(_ sender: UIButton) {
        UserSession.sharedSession.removeGuestItems()
       self.moveToMyOrdersListView()
    }
}
