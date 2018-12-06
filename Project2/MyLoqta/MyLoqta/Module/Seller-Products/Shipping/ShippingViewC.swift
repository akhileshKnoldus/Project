//
//  ShippingViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class ShippingViewC: UIViewController {

    var viewModel: ShippingVModeling?
    var dataModel = [[String: String]]()
    var responseBlock: ((_ param: [String: String]) -> Void)?
    
    @IBOutlet weak var tblShipping: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - Private functions
    
    private func setup() {
        self.recheckVM()
        if let array = self.viewModel?.getModel() {
            self.dataModel.append(contentsOf: array)
        }
        self.tblShipping.register(ShippingCell.self)
        self.tblShipping.reloadData()
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = ShippingVM()
        }
    }
    
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ShippingViewC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShippingCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.dataModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(self.dataModel[indexPath.row])")
        if let responseBlock = self.responseBlock {
            responseBlock(self.dataModel[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


