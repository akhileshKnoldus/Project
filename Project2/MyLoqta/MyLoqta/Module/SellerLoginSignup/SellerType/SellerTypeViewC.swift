//
//  SellerTypeViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SellerTypeViewC: BaseViewC {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblSellerType: UILabel!
    @IBOutlet weak var lblDifferenceDesc: UILabel!
    @IBOutlet weak var individualView: UIView!
    @IBOutlet weak var businessView: UIView!
    @IBOutlet weak var lblIndividual: UILabel!
    @IBOutlet weak var lblIndividualDesc: UILabel!
    @IBOutlet weak var lblBusiness: UILabel!
    @IBOutlet weak var lblBusinessDesc: UILabel!
    
    //MARK: - Variables
    var viewModel: SellerTypeVModeling?
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - PrivateMethods
    
    private func setup() {
        self.recheckVM()
        self.setupView()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerTypeVM()
        }
    }
    
    private func setupView() {
        self.individualView.makeLayer(color: UIColor.borderColor, boarderWidth: 1.0, round: 8.0)
        self.businessView.makeLayer(color: UIColor.borderColor, boarderWidth: 1.0, round: 8.0)
    }
    
    //MARK: - IBActions
    @IBAction func tapCross(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapIndividualSeller(_ sender: UIButton) {
        if let individualDocsVC = DIConfigurator.sharedInst().getIndividualSellerDocsVC() {
            self.navigationController?.pushViewController(individualDocsVC, animated: true)
        }
    }
    
    @IBAction func tapBusinessSeller(_ sender: UIButton) {
        if let businessDocsVC = DIConfigurator.sharedInst().getBusinessSellerDocsVC() {
            self.navigationController?.pushViewController(businessDocsVC, animated: true)
        }
    }
}
