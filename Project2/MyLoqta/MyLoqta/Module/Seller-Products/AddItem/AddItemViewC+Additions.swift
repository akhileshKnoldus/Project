//
//  AddItemViewC+Additions.swift
//  MyLoqta
//
//  Created by Ashish Chauhan on 23/07/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension AddItemViewC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.arraryModel.count + 1)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 5 {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerHt = section == 5 ? 20.0 : 10.0
        if section == 0 {
            headerHt = 0.0
        }
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Double(Constant.screenWidth), height: headerHt))
        view.backgroundColor = UIColor.colorWithRGBA(redC: 240, greenC: 244, blueC: 248, alfa: 0.5)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return 3
        case 1: return 3
        case 2: return 1
        case 3: return 2
        case 4: return 1
        case 5: return 2
        default: return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row
            {
            case 0: return 55
            case 1: return 130
            default: return UITableViewAutomaticDimension
            }
        case 1, 2: return 55
        case 4: return self.heightForTagsCell(indexPath: indexPath)
        case 3: let ht = (indexPath.row == 0) ?  55 :  UITableViewAutomaticDimension
            return ht
        case 5:
            if indexPath.row == 0 {
                return 0
            } else {
                if isEdit {
                    return 70.0
                } else {
                    return 143.0
                }
            }
        default: return 0
        }
    }
    
    func heightForTagsCell(indexPath: IndexPath) -> CGFloat {
        if let arrTags = self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kTags] as? [String], arrTags.count > 0 {
            return 75.0
        } else {
            return 55.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //return UITableViewCell()
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell: ItemNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            case 1:
                let cell: ItemPhotoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            default:
                let cell: ItemDescCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            }
        case 1,2,3:
            if indexPath.section == 1 && indexPath.row == 2 {
                let cell: QuantityCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
                cell.delegate = self
                return cell
            }
            if indexPath.section == 3 && indexPath.row == 1 {
                let cell: LocationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
                //cell.delegate = self
                return cell
            }
            
            let cell: AddItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row], indexPath: indexPath)
            cell.delegate = self
            return cell
            
        case 4: let cell: TagsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(data: self.arraryModel[indexPath.section][indexPath.row])
        cell.delegate = self
        return cell
            
        case 5:
            if indexPath.row == 0 {
                let cell: PromoteCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                return cell
            } else {
                let cell: SaveItemCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.delegate = self
                cell.isEdit = self.isEdit
                return cell
            }
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3, indexPath.row == 1 {
            if let addressListVC = DIConfigurator.sharedInst().getAddressList() {
                self.navigationController?.pushViewController(addressListVC, animated: true)
            }
        }
    }
    
    
}

extension AddItemViewC: AddItemProtocol {
    
    func removeKeyword(array: [String]) {
        
        var dict = self.arraryModel[4][0]// = array
        dict[Constant.keys.kTags] = array
        self.arraryModel[4][0] = dict        
        self.tblAddItem.reloadData()
    }
    
    func openKeyword() {
        Threads.performTaskAfterDealy(0.2) {        
            self.isShowDropDown = true
            self.txtFieldEmpty.becomeFirstResponder()
            self.txtFieldKeyword.becomeFirstResponder()
        }
    }
    
    func tapImage(cell: UITableViewCell) {
        if let indexPath = self.tblAddItem.indexPath(for: cell) {
            self.addImage(indexPath: indexPath)
        }
    }
    
    func getReceivingAmount(text: String, commission: CGFloat) -> String {
        if let totalValue = Double(text) {
            let dblCmsn = Double(commission)
            let finalValue = totalValue - (totalValue * dblCmsn/100)
            return "\(finalValue)"
        }
        return ""
    }
    
    func updateText(text: String, indexPath: IndexPath?, cell: UITableViewCell) {
        if let index = self.tblAddItem.indexPath(for: cell) {
            var dict = self.arraryModel[index.section][index.row]
            dict[Constant.keys.kValue] = text
            
            if index.section == 2, index.row == 0, let addCell = cell as? AddItemCell {
                let rcvngAmnt = self.getReceivingAmount(text: text, commission: self.commission)
                 dict[Constant.keys.k10Percent] = rcvngAmnt
                addCell.lblReceivePriceValue.text = rcvngAmnt
            }
            self.arraryModel[index.section][index.row] = dict
        }
    }
    
    func removeImage(imageIndex: Int, cell: UITableViewCell) {
        if let indexPath = self.tblAddItem.indexPath(for: cell) {
            if var array = self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] as? [[String: Any]] {
                array.remove(at: imageIndex)
                self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] = array
                self.tblAddItem.reloadData()
            }
        }
    }
    
    func increaseQuanity(shouldIncrease: Bool, cell: UITableViewCell) {
        
        let maxLimit = 10
        var sellerType = 1
        if let user = Defaults[.user], let seller = user.seller, let sellerTypeValue = seller.sellerType {
            sellerType = sellerTypeValue
        }
        
        if sellerType == 1 {
            return
        }
        
        if let indexPath = self.tblAddItem.indexPath(for: cell) {
            var dict = self.arraryModel[indexPath.section][indexPath.row]
            if var currentValue = dict[Constant.keys.kValue] as? Int {
                if shouldIncrease {
                    if sellerType == 2, currentValue >= maxLimit {
                        return
                    }
                    currentValue += 1
                } else {
                    currentValue -= 1
                    if currentValue < 1 {
                        currentValue = 1
                    }
                }
                dict[Constant.keys.kValue] = currentValue
                self.arraryModel[indexPath.section][indexPath.row] = dict
                self.tblAddItem.reloadData()
            }
        }
    }
    
    func pushToShipping(cell: UITableViewCell) {
        if let shippingVC = DIConfigurator.sharedInst().getShippingVC() {
            self.navigationController?.pushViewController(shippingVC, animated: true)
            shippingVC.responseBlock = { [weak self] (param: [String: String]) in
                guard let strongSelf = self else { return }
                if let indexPath = strongSelf.tblAddItem.indexPath(for: cell) {
                    var dict = strongSelf.arraryModel[indexPath.section][indexPath.row]
                    dict[Constant.keys.kValue] = param[Constant.keys.kTitle] ?? ""
                    strongSelf.arraryModel[indexPath.section][indexPath.row] = dict
                    strongSelf.tblAddItem.reloadData()
                }
            }
        }
    }
    
    func pushToCondition(cell: UITableViewCell) {
        if let conditionVC = DIConfigurator.sharedInst().getConditionVC() {
            self.navigationController?.pushViewController(conditionVC, animated: true)
            conditionVC.responseBlock = { [weak self] (condition: String) in
                guard let strongSelf = self else { return }
                if let indexPath = strongSelf.tblAddItem.indexPath(for: cell) {
                    var dict = strongSelf.arraryModel[indexPath.section][indexPath.row]
                    dict[Constant.keys.kValue] = condition 
                    strongSelf.arraryModel[indexPath.section][indexPath.row] = dict
                    strongSelf.tblAddItem.reloadData()
                }
            }
        }
    }
    
    func pushAddressList(cell: UITableViewCell) {
        if let addressListVC = DIConfigurator.sharedInst().getAddressList() {
            self.navigationController?.pushViewController(addressListVC, animated: true)
        }
    }
    
    func pushToCategory(cell: UITableViewCell) {
        if let categoryVC = DIConfigurator.sharedInst().getCategoryVC() {
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    func tapButton(actionType: ActionType) {
        self.processData(actionType: actionType)
    }
    
    func updateHeightOfRow(_ cell: ItemDescCell, _ textView: UITextView) {
        let size = textView.bounds.size
        let newSize = tblAddItem.sizeThatFits(CGSize(width: size.width,
                                                        height: CGFloat.greatestFiniteMagnitude))
        if size.height != newSize.height {
            
            UIView.setAnimationsEnabled(false)
            tblAddItem.beginUpdates()
            tblAddItem.endUpdates()
            UIView.setAnimationsEnabled(true)
            if let indexPath = tblAddItem.indexPath(for: cell), let text = textView.text {
                var dict = self.arraryModel[indexPath.section][indexPath.row]
                dict[Constant.keys.kValue] = text
                print("final text: \(text)")
                self.arraryModel[indexPath.section][indexPath.row] = dict
             //   tblAddItem.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
}
