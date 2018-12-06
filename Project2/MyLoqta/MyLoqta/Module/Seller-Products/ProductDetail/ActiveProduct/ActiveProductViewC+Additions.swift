//
//  ActiveProductViewC+Additions.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/23/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

//MARK: - CollectionViewDataSourceAndDelegates
extension ActiveProductViewC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productImageCell: ProductImagesCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let imageUrl = self.imgDataSource[indexPath.row]
        productImageCell.setImage(imageUrl: imageUrl)
        return productImageCell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControl.currentPage = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height + 20.0
        return CGSize(width: width, height: height)
    }
}

//MARK: - TableViewDataSourceAndDelegates
extension ActiveProductViewC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDict = self.dataSource[section]
        if let sectionIndex = sectionDict[Constant.keys.kSectionIndex] as? sectionIndex, let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]] {
            let count = array.count
            switch sectionIndex {
            case .firstSection:
                return isShowMore ? 3 : count
            case .secondSection:
                return count
            case .thirdSection:
                return count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCell(tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    
    private func getCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let sectionDict = self.dataSource[indexPath.section]
        if let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]] {
            let data = array[indexPath.row]
            if let cellType = data[Constant.keys.kCellType] as? cellType{
                switch cellType {
                case .productName:
                    return getCellForProductName(tableView, indexPath: indexPath)
                case .productDetail:
                    return getCellForProductDetail(tableView, indexPath: indexPath, data: data)
                case .productQuantity:
                    return getCellForProductQuantity(tableView, indexPath: indexPath, data: data)
                case .productQuestions:
                    return getCellForProductQuestions(tableView, indexPath: indexPath, data: data)
                case .productDeactivate:
                    return getCellForProductDeactivate(tableView, indexPath: indexPath, data: data)
                default:
                    break
                }
            }
        }
        return UITableViewCell()
    }
    
    private func getCellForProductName(_ tableView: UITableView, indexPath: IndexPath) -> ProductNameCell {
        let cell: ProductNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDataOnView(self.product)
        return cell
    }
    
    private func getCellForProductDetail(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductDetailCell {
        let cell: ProductDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if let title = data[Constant.keys.kTitle] as? String, title == "Description".localize(), isShowMore {
            cell.isShowMore = true
        } else {
            cell.isShowMore = false
        }
        cell.configureDataOnView(data)
        return cell
    }
    
    private func getCellForProductQuantity(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductQuantityCell {
        let cell: ProductQuantityCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureDataOnView(data)
        return cell
    }
    
    private func getCellForProductQuestions(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> UITableViewCell {
        print("data:\(data)")
        
        if let question = data[Constant.keys.kValue] as? Question {
            if let arrayReply = question.reply, arrayReply.count > 0 {
                let cell: DetailProductQuestion = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configreCell(question: question, indexPath: indexPath)
                return cell
            } else {
                let cell: ProductQuestionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.configureCell(question: question)
                cell.delegate = self
                cell.weakDelegate = self
                return cell
            }
        }
        return UITableViewCell()
    }
    
    private func getCellForProductAnswers(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductAnswerCell {
        let cell: ProductAnswerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    private func getCellForProductDeactivate(_ tableView: UITableView, indexPath: IndexPath, data: [String: Any]) -> ProductDeactivateCell {
        let cell: ProductDeactivateCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    private func getSectionHeaderView() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.colorWithRGBA(redC: 239.0, greenC: 243.0, blueC: 247.0, alfa: 1.0)
        let whiteView = UIView(frame: CGRect(x: 0, y: 20, width: self.tblViewDetails.frame.size.width, height: 30))
        whiteView.backgroundColor = .white
        let lblTitle = UILabel(frame: CGRect(x: 16, y: 10, width: 100, height: 15))
        lblTitle.font = UIFont.font(name: .SFProText, weight: .Regular, size: .size_13)
        lblTitle.textColor = UIColor.colorWithRGBA(redC: 166.0, greenC: 166.0, blueC: 166.0, alfa: 1.0)
        lblTitle.text = "Questions".localize()
        whiteView.addSubview(lblTitle)
        view.addSubview(whiteView)
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionDict = self.dataSource[indexPath.section]
        if let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]] {
            let data = array[indexPath.row]
            if let cellType = data[Constant.keys.kCellType] as? cellType {
                switch cellType {
                case .productName:
                    return 110.0
                case .productDetail:
                    return 110.0
                case .productQuantity:
                    return 55.0
                case .productQuestions:
                    return 153.0
                case .productDeactivate:
                    return 55.0
                default:
                    break
                }
            }
        }
        return 55.0
    }
    
    
    func getHeightOfQuestionAnsCell(indexPath: IndexPath) -> CGFloat {
        
        if let array = self.product?.arrayQuestion {
            return UserSession.sharedSession.getHeightOfQuestionCell(question: array[indexPath.row])
        } else {
            if indexPath.row == 0 , let productDetail = self.product, let array = productDetail.arrayQuestion, array.count > 0 {
                return UserSession.sharedSession.getHeightOfQuestionCell(question: array[indexPath.row])
            } else if indexPath.row > 0 {
                return 80
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionDict = self.dataSource[indexPath.section]
        if let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]] {
            let data = array[indexPath.row]
            if let cellType = data[Constant.keys.kCellType] as? cellType {
                switch cellType {
                case .productName:
                    return 110.0
                case .productQuestions:
                    return self.getHeightOfQuestionAnsCell(indexPath: indexPath)
                case .productDetail:
                    if indexPath.section == 0, indexPath.row == 2, isShowMore {
                        return 100.0
                    } else {
                        return UITableViewAutomaticDimension
                    }
                default:
                    return UITableViewAutomaticDimension
                }
            }
        }
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionDict = self.dataSource[section]
        if let sectionIndex = sectionDict[Constant.keys.kSectionIndex] as? sectionIndex {
            switch sectionIndex {
            case .secondSection :
                if let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]], array.count > 0 {
                return getSectionHeaderView()
                }
            default:
                return nil
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionDict = self.dataSource[section]
        if let sectionIndex = sectionDict[Constant.keys.kSectionIndex] as? sectionIndex {
            switch sectionIndex {
            case .secondSection :
                if let array = sectionDict[Constant.keys.kDataSource] as? [[String: Any]], array.count > 0 {
                    return 50.0
                } else {
                    return 0.0
                }
            case .thirdSection :
                return 10.0
            default:
                return 0.0
            }
        }
        return 0.0
    }
}

extension ActiveProductViewC: ProductDetailCellDelegate {
    func didTapShowMore() {
        self.isShowMore = false
        self.tblViewDetails.reloadData()
    }
    
    func replyToAnswer(text: String, question: Question) {
        self.view.endEditing(true)
        if let questionId = question.questionId, let sellerId = self.product?.sellerId {
            let param: [String: AnyObject] = ["questionId": questionId as AnyObject,
                                              "sellerId": sellerId as AnyObject,
                                              "reply": text as AnyObject]
            self.viewModel?.requestToReplyAQuestions(param: param, completion: {[weak self] (success) in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.getProductDetail()
                }
            })
        }
    }
}

extension ActiveProductViewC: ProductDeactivateCellDelegate {
    func didTapDeactivate() {
        Alert.showAlertWithActionWithColor(title: ConstantTextsApi.AppName.localizedString, message: "Are you sure, you want to deactivate this product?".localize(), actionTitle: "Yes".localize(), showCancel: true, action: { (action) in
            self.requestDeactivateProduct()
        })
    }
}

extension ActiveProductViewC: DismissKeyboardDelegates {
    func didPerformActionOnDismissingKeyboard() {
        self.view.endEditing(true)
    }
}
