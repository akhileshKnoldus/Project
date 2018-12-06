//
//  CategoryViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class CategoryViewC: UIViewController {

    @IBOutlet weak var tblCategory: UITableView!
    var viewModel: CategoryVModeling?
    var arrayCategory = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setup() {
        self.recheckVM()
        self.tblCategory.register(CategoryCell.self)
        //self.viewModel?.getCategory()
        //self.viewModel?.getSubCategory()
        let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject]
        self.viewModel?.getCategory(param: param, completion: {[weak self] (arrayCate) in
            guard let strongSelf = self else { return }
            strongSelf.arrayCategory.append(contentsOf: arrayCate)
            strongSelf.tblCategory.reloadData()
            
        })
        
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = CategoryVM()
        }
    }
    
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }

}

extension CategoryViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCategoryCell(category: self.arrayCategory[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = self.arrayCategory[indexPath.row]
        if let subCategoryVC = DIConfigurator.sharedInst().getSubCategoryVC() {
            subCategoryVC.category = category
            self.navigationController?.pushViewController(subCategoryVC, animated: true)
            
        }
    }
    
    
}

