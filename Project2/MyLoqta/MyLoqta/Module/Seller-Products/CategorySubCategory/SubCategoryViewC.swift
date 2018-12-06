//
//  SubCategoryViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 24/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SubCategoryViewC: UIViewController {
    
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var tblSubCategory: UITableView!
    var viewModel: CategoryVModeling?
    var arraySubCat = [SubCategoryModel]()
    
    var category: CategoryModel?
    
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
    
    private func setup() {
        self.recheckVM()
        self.tblSubCategory.register(CategoryCell.self)
        self.requestSubCatApi()
        
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
    
    func requestSubCatApi() {
        if let cate = self.category, let idValue = cate.id, let title = cate.name {
            self.lblTitle.text = title
            let param: [String: AnyObject] = ["key": 1 as AnyObject, "page": 1 as AnyObject, "categoryId": idValue as AnyObject]
            self.viewModel?.getSubCategory(param: param, completion: {[weak self] (arrayCate) in
                guard let strongSelf = self else { return }
                strongSelf.arraySubCat.append(contentsOf: arrayCate)
                strongSelf.tblSubCategory.reloadData()
            })
        }
    }

}

extension SubCategoryViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arraySubCat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CategoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureSubCategoryCell(category: self.arraySubCat[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subCategory = self.arraySubCat[indexPath.row]
        if let arrayViewC = self.navigationController?.viewControllers, let category = self.category {
            
            // Pop to AddItemViewC
            for viewController in arrayViewC {
                if viewController is AddItemViewC, let addItemVC = viewController as? AddItemViewC {
                    addItemVC.updateCategory(category: category, subCate: subCategory)
                    self.navigationController?.popToViewController(addItemVC, animated: true)
                    return
                }
            }
            
            // Pop to FilterViewC
            for viewController in arrayViewC {
                if viewController is FilterViewC, let filterVC = viewController as? FilterViewC {
                    filterVC.updateCategory(category: category, subCate: subCategory)
                    self.navigationController?.popToViewController(filterVC, animated: true)
                    return
                }
            }
        }
        
        
        
    }
    
    
}
