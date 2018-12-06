//
//  SellerEmptyProfileViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerEmptyProfileViewC: BaseViewC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblStartEarning: UILabel!
    @IBOutlet weak var lblWayDescription: UILabel!
    @IBOutlet weak var lblAddImageDesc: UILabel!
    @IBOutlet weak var lblGetPaidDesc: UILabel!
    @IBOutlet weak var lblWeDeliverDesc: UILabel!
    @IBOutlet weak var btnBecomeSeller: AVButton!
    
    //MARK: - Variables
    internal var viewModel: SellerEmptyProfileVModeling?
    
    // MARK: - LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        
        self.view.bringSubview(toFront: self.containerView)
        if let viewBg = self.view as? ColorBgView {
            viewBg.updateBackgroudForSeller()
        }
        self.recheckVM()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerEmptyProfileVM()
        }
    }
    
    // MARK: - IBActions
    @IBAction func tapCross(_ sender: UIButton) {
        AppDelegate.delegate.showHome()
    }
    
    @IBAction func tapBecomeSeller(_ sender: UIButton) {
        if let sellerTypeVC = DIConfigurator.sharedInst().getSellerTypeVC() {
            self.navigationController?.pushViewController(sellerTypeVC, animated: true)
        }
    }
}
