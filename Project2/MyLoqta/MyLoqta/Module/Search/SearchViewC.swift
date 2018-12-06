//
//  SearchViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 10/08/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class SearchViewC: UIViewController {

    @IBOutlet weak var cnstHtTopView: NSLayoutConstraint!
    @IBOutlet weak var tblViewSearch: UITableView!
    @IBOutlet weak var btnThird: UIButton!
    @IBOutlet weak var btnSecond: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var cnstBottomTable: NSLayoutConstraint!
    @IBOutlet weak var noDataView: UIView!
    
    //MARK: - Variables
    var viewModel: SearchVModeling?
    var arraySearch = [SearchResult]()
    var arrayKeyword = [SearchResult]()
    var arrayProduct = [Product]()
    var page = 1
    var searchType = 1
    var isBlank = true {
        didSet {
            self.setupHeader()
        }
    }
    
    //NARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "cross"), target: self, action: #selector(tapBack))
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.txtFieldSearch.text = ""
        
        //self.updateHeaderView(isEmpty: true)
        //self.arraySearch.removeAll()
        //self.tblViewSearch.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Private fuctions
    private func setup() {
        self.recheckVM()
        self.setupHeader()
        self.resetAllButton(sender: btnFirst)
        self.registerNib()
        self.txtFieldSearch.autocorrectionType = .no
//        self.txtFieldSearch.becomeFirstResponder()
        self.txtFieldSearch.inputAccessoryView = Helper.getDoneToolBarInstanceWith(selector: #selector(tapDone), target: self)
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SearchVM()
        }
        self.requestApiRecentViewItem()
    }
    
    private func registerNib() {
        self.tblViewSearch.register(SearchResutlCell.self)
        self.tblViewSearch.register(SearchCacheCell.self)
        self.tblViewSearch.register(RecentItemTableCell.self)
        self.tblViewSearch.register(SearchStoreCell.self)
        
    }
    
    private func updateHeaderView(isEmpty: Bool) {
        if isBlank == isEmpty {
            return
        }
        isBlank = isEmpty
        if isEmpty {
            self.requestApiRecentViewItem()
        }
    }
    
    
    
    private func setupHeader() {
        
        if isBlank {
            self.updateButtons(shouldHide: false)
            self.btnFirst.setTitle("Recent".localize(), for: [])
            self.btnSecond.setTitle("".localize(), for: [])
            self.cnstHtTopView.constant = 50
        } else {
            self.cnstHtTopView.constant = 50
            self.updateButtons(shouldHide: false)
            self.btnFirst.setTitle("Product".localize(), for: [])
            self.btnSecond.setTitle("Store".localize(), for: [])
            //self.btnThird.setTitle("Tag".localize(), for: [])
        }
        self.resetAllButton(sender: self.btnFirst)
    }
    
    func resetAllButton(sender: UIButton) {
        
        self.btnFirst.isSelected = false
        self.btnSecond.isSelected = false
        //self.btnThird.isSelected = false
        sender.isSelected = true
    }
    
    func updateButtons(shouldHide: Bool) {
        //self.btnThird.isHidden = shouldHide
        self.btnFirst.isHidden = shouldHide
        self.btnSecond.isHidden = shouldHide
    }

    //MARK: - Selector Methods
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapDone() {
        self.txtFieldSearch.resignFirstResponder()
    }
    
    @IBAction func tapHeader(_ sender: UIButton) {
    
        if sender.isSelected {
            return
        }
    
        self.resetAllButton(sender: sender)
        if let buttonTitle = sender.title(for: .normal) {
            switch buttonTitle {
            case "Recent".localize(): break
            case "Saved".localize(): break
            case "Product".localize(): break
            case "Store".localize(): break
            case "Tag".localize(): break
            default:break
            }
        }
        
        self.searchType = sender.tag
        self.page = 1
        if let text = self.txtFieldSearch.text {
            self.requestToSearch(text: text)
        }
    }
    
    func processRecentItmes(arrayKeword: [SearchResult], arrayProduct: [Product]) {
        self.arrayKeyword.removeAll()
        self.arrayProduct.removeAll()
        self.arrayKeyword.append(contentsOf: arrayKeword)
        self.arrayProduct.append(contentsOf: arrayProduct)
        self.noDataView.isHidden = self.arrayKeyword.count > 0 ? true : false
        self.tblViewSearch.reloadData()
        
    }
    
    // MARK: - Api functions
    @objc func requestToSearch(text: String) {
        if text.isEmpty || text.utf8.count <= 1 {
            return
        }
        print("text is::::::::::::::::::::::::::: \(text)")
        let param = ["tabType": searchType as AnyObject,
                     "page": page as AnyObject,
                     "searchText": text.trim() as AnyObject ]
        self.viewModel?.searchProduct(param: param, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            if strongSelf.page == 1 {
                strongSelf.arraySearch.removeAll()
            }
            strongSelf.arraySearch.append(contentsOf: result)
            strongSelf.noDataView.isHidden = strongSelf.arraySearch.count > 0 ? true : false
            strongSelf.tblViewSearch.reloadData()
        })
    }
    
    
    func requestApiRecentViewItem() {
        self.viewModel?.viewRecentItems(completion: { [weak self] (arrayKeyword, arrayProduct) in
            guard let strongSelf = self else { return }
            
            strongSelf.processRecentItmes(arrayKeword: arrayKeyword, arrayProduct: arrayProduct)
        })
    }
}

extension SearchViewC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text, let textRange = Range(range, in: text) {
            let finalText = text.replacingCharacters(in: textRange, with: string)
            self.updateHeaderView(isEmpty: finalText.isEmpty)
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(requestToSearch(text:)), with: finalText, afterDelay: 0.5)
        }
        
        return true
    }
}

extension SearchViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 65
        case 1: return 50            
        default: return 200
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return self.arraySearch.count // Search result
        case 1: return ( self.arraySearch.count > 0 ? 0 : self.arrayKeyword.count)
        default: return ( self.arraySearch.count > 0 ? 0 : 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: return self.getSearchedItemCell(tableView: tableView, indexPath: indexPath)
        case 1: return self.getCatcheCell(tableView: tableView, indexPath: indexPath)
        default: return self.getRecentItemCell(tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        if indexPath.section == 0 {
            let search = self.arraySearch[indexPath.row]
            if btnFirst.isSelected {
                if let searchDetail = DIConfigurator.sharedInst().getSearchDetailVC() {
                    searchDetail.item = search
//                    searchDetail.delegate = self
                    self.navigationController?.pushViewController(searchDetail, animated: true)
                }
            } else {
                if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC(), let storeId = search.storeId, storeId > 0 {
                    //sellerProfileVC.isSelfProfile = false
                    sellerProfileVC.sellerId = storeId
                    //sellerProfileVC.delegate = self
                    self.navigationController?.pushViewController(sellerProfileVC, animated: true)
                }
            }
        } else if indexPath.section == 1 {
            let data = self.arrayKeyword[indexPath.row]
            if let type = data.type {
                if type == 1 { //KeyWord
                    if let searchDetail = DIConfigurator.sharedInst().getSearchDetailVC() {
                        searchDetail.item = data
//                        searchDetail.delegate = self
                        self.navigationController?.pushViewController(searchDetail, animated: true)
                    }
                } else if type == 2 { //Store
                    if let sellerProfileVC = DIConfigurator.sharedInst().getSellerProfileVC(), let storeId = data.storeId, storeId > 0 {
                        //sellerProfileVC.isSelfProfile = false
                        sellerProfileVC.sellerId = storeId
                        //sellerProfileVC.delegate = self
                        self.navigationController?.pushViewController(sellerProfileVC, animated: true)
                    }
                }
            }
        }
    }
    
    func getSearchedItemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        
        if self.btnFirst.isSelected {
            let cell: SearchResutlCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(searchItem: self.arraySearch[indexPath.row])
            return cell
        } else {
            let cell: SearchStoreCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(searchResult: self.arraySearch[indexPath.row])
            return cell
        }
    }
    
    func getCatcheCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchCacheCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let data = self.arrayKeyword[indexPath.row]
        if let type = data.type {
            if type == 1 {
                if let title = data.itemName {
                    cell.lblKeyword.text = title
                } else {
                    cell.lblKeyword.text = ""
                }
            } else if type == 2 {
                if let title = data.storeName {
                    cell.lblKeyword.text = title
                } else {
                    cell.lblKeyword.text = ""
                }
            }
        }
        return cell
    }
    
    func getRecentItemCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentItemTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(array: self.arrayProduct)
        cell.searchDelegate = self
        return cell
    }
}

extension SearchViewC: SearchDelegate {
    func tapProduct(product: Product) {
        if let itemId = product.itemId, let detailVC = DIConfigurator.sharedInst().getBuyerProducDetail() {
            detailVC.productId = itemId
            detailVC.detailType = 2
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
