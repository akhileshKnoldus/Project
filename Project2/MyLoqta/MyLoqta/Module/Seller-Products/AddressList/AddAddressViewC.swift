//
//  AddAddressViewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding

class AddAddressViewC: BaseViewC {

    
    @IBOutlet weak var tblViewAddAddress: TPKeyboardAvoidingTableView!
    //@IBOutlet weak var tblViewAddAddress: UITableView!
    var viewModel: AddressListVModeling?
    var shippingAddress: ShippingAddress?
    var arrayModel = [Address]()
    var refreshList: (()->Void)?
    var arrCountry = [[String: Any]]()
    var arrCity = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Private functions
    private func setup() {
        self.recheckVM()
        self.tblViewAddAddress.register(AddNewAddressCell.self)
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
        if let array = self.viewModel?.getAddAddressDataSource(address: self.shippingAddress) {
            self.arrayModel.append(contentsOf: array)
            self.tblViewAddAddress.reloadData()
        }
        self.getCityList()
        if let arrayCountry = self.viewModel?.getCountryList() {
            self.arrCountry = arrayCountry
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = AddressListVM()
        }
    }
    
    private func getCityList() {
        let param = ["key": 1 as AnyObject]
        self.viewModel?.getCityList(param: param, completion: {[weak self] (arrayCity) in
            guard let strongSelf = self else { return }
            strongSelf.arrCity = arrayCity
        })
    }
    
    // MARK: - IBAction functions
    @objc func tapBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAddAddress(_ sender: Any) {
        if let viewModel = viewModel, viewModel.validateData(self.arrayModel) {
            
            var param: [String: AnyObject] = ["userId": UserSession.sharedSession.getUserId() as AnyObject,
                                              "title": arrayModel[0].value as AnyObject,
                                              "country": arrayModel[1].value as AnyObject,
                                              "city": arrayModel[2].value as AnyObject,
                                              "blockNo": arrayModel[3].value as AnyObject,
                                              "street": arrayModel[4].value as AnyObject,
                                              "avenueNo": arrayModel[5].value as AnyObject,
                                              "buildingNo": arrayModel[6].value as AnyObject,
                                              "paciNo": arrayModel[7].value as AnyObject]
            if let address = self.shippingAddress, let addressId = address.id {
                param["addressId"] = addressId as AnyObject
                self.editAddress(param: param)
                return
            }
            
            self.viewModel?.addAddress(param: param, completion: { [weak self] (success, address) in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.sendAddressToAddItem(address: address)
                }
            })
        }
        
/*"userId": "311",
 "title": "office",
 "country" : "Australia",
 "city" : "Sydney",
 "blockNo" : "166",
 "street" : "33",
 "avenueNo" : "",
 "buildingNo":"3",
 "paciNo": "12345"*/
    }
    
    func editAddress(param: [String: AnyObject]) {
        self.viewModel?.updateAddress(param: param, completion: {[weak self] (success) in
            guard let strongSelf = self else { return }
            if success, let refreshList = strongSelf.refreshList {
                refreshList()
                strongSelf.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    func sendAddressToAddItem(address: ShippingAddress) {
        if let arrayViewC = self.navigationController?.viewControllers {
            for viewController in arrayViewC {
                if viewController is AddItemViewC, let addItemVC = viewController as? AddItemViewC {
                    addItemVC.updateAddress(shippingAdd: address)
                    self.navigationController?.popToViewController(addItemVC, animated: true)
                    break
                }
                if viewController is SellerEditProfileViewC, let sellerEditProfileVC = viewController as? SellerEditProfileViewC {
                    sellerEditProfileVC.updateAddress(shippingAdd: address)
                    self.navigationController?.popToViewController(sellerEditProfileVC, animated: true)
                    break
                }
                if viewController is AddressListVewC, let addressListViewC = viewController as? AddressListVewC {
                    if let refreshList = self.refreshList {
                        refreshList()
                        self.navigationController?.popViewController(animated: true)
                    }
                    break
                }
            }
        }
    }
    
    func showCountryPopup(indexPath: IndexPath) {
        if self.arrCountry.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select country".localize(), arrayList: self.arrCountry as [[String : AnyObject]], keyValue: "countryName") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let countryName = result["countryName"] as? String {
                    var address = strongSelf.arrayModel[indexPath.row]
                    address.value = countryName
                    strongSelf.arrayModel[indexPath.row] = address
                    strongSelf.tblViewAddAddress.reloadData()
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
    
    func showCityPopup(indexPath: IndexPath) {
        if self.arrCity.count > 0 {
            let popup = PopUpSearchView()
            popup.initWithTitle(title: "Select city".localize(), arrayList: self.arrCity as [[String : AnyObject]], keyValue: "name") { [weak self] (response) in
                print(response)
                guard let strongSelf = self else { return }
                if let result = response as? [String: AnyObject], let cityName = result["name"] as? String {
                    var address = strongSelf.arrayModel[indexPath.row]
                    address.value = cityName
                    strongSelf.arrayModel[indexPath.row] = address
                    strongSelf.tblViewAddAddress.reloadData()
                }
            }
            popup.showWithAnimated(animated: true)
        }
    }
}

extension AddAddressViewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddNewAddressCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arrayModel[indexPath.row], indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.showCountryPopup(indexPath: indexPath)
        case 2:
            self.showCityPopup(indexPath: indexPath)
        default:
            break
        }
    }
}

extension AddAddressViewC: AddAddressProtocol {
    func tapNexKeyboard(cell: UITableViewCell) {
        if var indexPath = self.tblViewAddAddress.indexPath(for: cell) {
            indexPath.row += 1
            if let cell = self.tblViewAddAddress.cellForRow(at: indexPath) as? AddNewAddressCell {
                cell.txtFieldAddress.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        }
    }
    
    func updateText(text: String, cell: UITableViewCell) {
        if let indexPath = self.tblViewAddAddress.indexPath(for: cell) {
            var address = self.arrayModel[indexPath.row]
            address.value = text
            self.arrayModel[indexPath.row] = address
        }
    }
}

