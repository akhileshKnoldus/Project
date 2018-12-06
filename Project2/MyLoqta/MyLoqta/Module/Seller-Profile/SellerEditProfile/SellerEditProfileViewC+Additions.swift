//
//  SellerEditProfileViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK: - TableViewDataSourceAndDelegates
extension SellerEditProfileViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.arrayData.count+1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getProfileCoverCell(indexPath, tableView: tableView)
        case 1:
            return self.typeSeller == .individual ? getDescriptionCell(indexPath, tableView: tableView) : getProfileNameCell(indexPath, tableView: tableView)
        case 2:
            return self.typeSeller == .individual ? getStoreAddressCell(indexPath, tableView: tableView) : getDescriptionCell(indexPath, tableView: tableView)
        case 3:
            return self.typeSeller == .individual ? getAddNewAddressCell(indexPath, tableView: tableView) : getStoreAddressCell(indexPath, tableView: tableView)
        case 4:
            return self.typeSeller == .individual ? getSaveButtonCell(indexPath, tableView: tableView) : getAddNewAddressCell(indexPath, tableView: tableView)
        default:
            return getSaveButtonCell(indexPath, tableView: tableView)
        }
    }
    
    private func getProfileCoverCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileCoverCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let imageData = self.arrayData[indexPath.row]
        cell.configureEditProfileView(data: imageData, cvImgStatus: self.coverImageStatus, pfImgStatus: self.profileImageStatus)
        return cell
    }
    
    private func getProfileNameCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.nameDelegate = self
        if let aboutStore = self.arrayData[indexPath.row][Constant.keys.kValue] as? String {
            cell.txtFieldInfo.text = aboutStore
        }
        return cell
    }
    
    private func getDescriptionCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.lblTitle.text = self.typeSeller == .individual ? "Few words about you".localize() : "About store".localize()
        if let desc = self.arrayData[indexPath.row][Constant.keys.kValue] as? String {
            cell.txtViewInfo.text = desc
        }
        return cell
    }
    
    private func getEditPhoneCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: EditPhoneCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.txtFieldInfo.isSecureTextEntry = indexPath.row == 3 ? true : false
        cell.configureCell(data: self.arrayData[indexPath.row])
        return cell
    }
    
    private func getStoreAddressCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: StoreAddressTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arrayData[indexPath.row])
        return cell
    }
    
    private func getAddNewAddressCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: AddNewAddressTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.weakDelegate = self
        return cell
    }
    
    private func getSaveButtonCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: SaveButtonTableCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
        case 4:
            return 55.0
        default:
            return 65.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
        case 1:
            return self.typeSeller == .individual ? 90.0 : 65.0
        case 2:
            return self.typeSeller == .individual ? UITableViewAutomaticDimension : 90.0
        case 3:
            return self.typeSeller == .individual ? 55.0 : UITableViewAutomaticDimension
        case 4:
            return self.typeSeller == .individual ? 75.0 : 55.0
        case 5:
            return 75.0
        default:
            return 65.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 2: if self.typeSeller == .individual { self.moveToAddressListingViewC() }
        case 3: if self.typeSeller == .business { self.moveToAddressListingViewC() }
        default:
            break
        }
    }
}

//MARK: - ProfileCoverCellDelegate
extension SellerEditProfileViewC: ProfileCoverCellDelegate {
    
    func profileImageDidTap() {
        self.selectProfileImage()
    }
    
    func coverImageDidTap() {
        self.selectCoverImage()
    }
}

//MARK: - EditNameCellDelegate

extension SellerEditProfileViewC: EditNameCellDelegate {
    func nameChanged(text: String, isFirstName: Bool) {
        
    }
    
    func tapNexKeyboard(cell: UITableViewCell) {
        if var indexPath = self.tblViewEditProfile.indexPath(for: cell) {
            indexPath.row += 1
            if let cell = self.tblViewEditProfile.cellForRow(at: indexPath) as? ProfileDescriptionCell {
                cell.txtViewInfo.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        }
    }
    
    func textChanged(_ text: String, cell: UITableViewCell) {
        if let index = self.tblViewEditProfile.indexPath(for: cell) {
            self.arrayData[index.row][Constant.keys.kValue] = text
        }
    }
}

//MARK: - ProfileDescriptionCellDelegate
extension SellerEditProfileViewC: ProfileDescriptionCellDelegate {
    func textDidChange(_ text: String) {
        if self.typeSeller == .individual {
            self.arrayData[1][Constant.keys.kValue] = text
        } else {
            self.arrayData[2][Constant.keys.kValue] = text
        }
    }
}

//MARK:- AddNewAddress Delegates
extension SellerEditProfileViewC: AddNewAddressDelegates {
    func didPerformActionOnAddNewAddress() {
        self.moveToAddAddressViewC()
    }
}

//MARK: - SaveButtonDelegate
extension SellerEditProfileViewC: SaveButtonDelegate {
    func didTapSave() {
        if self.typeSeller == .individual {
            self.requestEditIndividualProfile()
        } else {
            self.requestEditStore()
        }
    }
}
