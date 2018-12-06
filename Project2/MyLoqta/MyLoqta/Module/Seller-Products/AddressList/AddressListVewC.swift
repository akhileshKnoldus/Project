//
//  AddressListVewC.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 26/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import SwipeCellKit
import MGSwipeTableCell

class AddressListVewC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tblViewAddressList: UITableView!
    
    //MARK:- Variables
    var viewModel: AddressListVModeling?
    var arrayShipping = [ShippingAddress]()
    var isForCheckout = Bool()
    var isForBuyNow = Bool()
    
    //MARK:- View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Private functions
    private func setup() {
        self .recheckVM()
        self.tblViewAddressList.register(AddressCell.self)
        self.tblViewAddressList.register(AddAddressCell.self)
        self.navigationController?.presentTransparentNavigationBar()
        self.addLeftButton(image: #imageLiteral(resourceName: "arrow_left_black"), target: self, action: #selector(tapBack))
        self.getAddressList()
        
    }
    
    private func getAddressList() {
        self.viewModel?.getAddressList(completion: { [weak self] (arrayAddress) in
            guard let strongSelf = self else { return }
            strongSelf.arrayShipping.removeAll()
            strongSelf.arrayShipping.append(contentsOf: arrayAddress)
            strongSelf.tblViewAddressList.reloadData()
        })
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = AddressListVM()
        }
    }

    
    //Swipe Methods
    private func swipeActionForEditOptions(_ cell: AddressCell) {
        let editButton = MGSwipeButton(title: "Edit".localize(), icon: nil ,backgroundColor: UIColor.appOrangeColor) {
            (sender: MGSwipeTableCell!) -> Bool in
            if let indexPath = self.tblViewAddressList.indexPath(for: cell) {
                print(indexPath.row)
                self.editAddress(shippingAdd: self.arrayShipping[indexPath.row])
            }
            return true
        }
        let deleteButton = MGSwipeButton(title: "Delete".localize(), icon: nil ,backgroundColor: UIColor.red) {
            (sender: MGSwipeTableCell!) -> Bool in
            if let indexPath = self.tblViewAddressList.indexPath(for: cell) {
                print(indexPath.row)
                self.deleteAddress(shippingAdd: self.arrayShipping[indexPath.row], index: indexPath.row)
            }
            return true
        }
        
        cell.rightButtons = [deleteButton,editButton]
        cell.rightSwipeSettings.transition = .drag
    }
    
    func moveToCheckoutViewC(_ addressId: Int) {
        if let checkoutViewC = DIConfigurator.sharedInst().getCheckoutVC() {
            checkoutViewC.addressId = addressId
            checkoutViewC.isForBuyNow = self.isForBuyNow
            self.navigationController?.pushViewController(checkoutViewC, animated: true)
        }
    }
    
    // MARK: - Public functions
    
    // Delete address
    
    
    func deleteAddress(shippingAdd: ShippingAddress, index: Int) {
        if let addressid = shippingAdd.id {
            Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Are you sure, you want to delete this address?".localize(), actionTitle: "Ok".localize(), showCancel: true, action: { (action) in
                self.viewModel?.removeAddress(addressId: addressid, completion: {[weak self] (success) in
                    guard let strongSelf = self else { return }
                    strongSelf.arrayShipping.remove(at: index)
                    strongSelf.tblViewAddressList.reloadData()
                })
            })
        }
    }
    
    // Edit address
    func editAddress(shippingAdd: ShippingAddress) {
        if let addAddressVC = DIConfigurator.sharedInst().getAddAddressVC() {
            addAddressVC.shippingAddress = shippingAdd
            self.navigationController?.pushViewController(addAddressVC, animated: true)
            addAddressVC.refreshList = { [weak self]  in
                guard let strongSelf = self else { return }
                strongSelf.getAddressList()
            }
        }
    }
    
    // MARK: - IBAction functins
    @objc func tapPushToAddNewAddress() {
        
        if let addAddressVC = DIConfigurator.sharedInst().getAddAddressVC() {
            self.navigationController?.pushViewController(addAddressVC, animated: true)
            addAddressVC.refreshList = { [weak self]  in
                guard let strongSelf = self else { return }
                strongSelf.getAddressList()
            }
        }
    }
    
    @objc func tapBack() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let array = self.navigationController?.viewControllers {
            var shouldUpdate = false
            var newArray = array
            for viewC in array {
                if self.viewControllerExist(viewC: viewC), let index = newArray.index(of: viewC) {
                    newArray.remove(at: index)
                    shouldUpdate = true
                }
            }
            if shouldUpdate {
                self.navigationController?.viewControllers = newArray
            }
        }        
        self.navigationController?.popViewController(animated: true)
    }
    
    func viewControllerExist(viewC: UIViewController) -> Bool {
        var isExist = false
        if (viewC is EmptyProfileViewC) || (viewC is LoginViewC) || (viewC is SignupViewC) || (viewC is VerifyPhoneViewC) || (viewC is OTPViewC) {
            isExist = true
        }
        return isExist
    }
    
}

extension AddressListVewC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayShipping.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.arrayShipping.count {
            return 56
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.arrayShipping.count {
            let cell: AddAddressCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.btnNewAddress.addTarget(self, action: #selector(tapPushToAddNewAddress), for: .touchUpInside)
            return cell
        } else {
            let cell: AddressCell = tblViewAddressList.dequeueReusableCell(forIndexPath: indexPath)
            cell.selectionStyle = .none
            cell.configureCell(address: self.arrayShipping[indexPath.row])
            self.swipeActionForEditOptions(cell)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.arrayShipping.count {
            if isForCheckout {
                let address = self.arrayShipping[indexPath.row]
                if let addressId = address.id {
                    self.moveToCheckoutViewC(addressId)
                }
                
            } else {
                let address = self.arrayShipping[indexPath.row]
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
                    }
                }
            }
        }
    }
}

//MARK: - MGSwipeTableCellDelegate
extension AddressListVewC: MGSwipeTableCellDelegate {
    
    public func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection, from point: CGPoint) -> Bool {
            return true
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        /*
        print("index is \(index)")
        if let indexPath = self.tblViewAddressList.indexPath(for: cell) {
            // Delete Adddress
            if index == 0 {
                self.deleteAddress(shippingAdd: self.arrayShipping[indexPath.row], index: indexPath.row)
            }
            // Edit address
            if index == 1 {
                
            }
        }*/
        return true
    }
}



