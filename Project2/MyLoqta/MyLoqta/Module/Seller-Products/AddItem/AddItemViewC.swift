    //
    //  AddItemViewC.swift
    //  MyLoqta
    //
    //  Created by Ashish Chauhan on 21/07/18.
    //  Copyright © 2018 AppVenturez. All rights reserved.
    //
    
    import UIKit
    import TPKeyboardAvoiding
    import SwiftyUserDefaults
    
    protocol AddItemViewDelegate: class {
        func didTapSaveProduct()
    }
    
    class AddItemViewC: UIViewController {
        
        @IBOutlet weak var txtFieldKeyword: UITextField!
        @IBOutlet var viewKeyword: UIView!
        @IBOutlet weak var lblHeading: AVLabel!
        @IBOutlet weak var tblAddItem: TPKeyboardAvoidingTableView!
        var viewModel: AddItemVModeling?
        var arraryModel = [[[String: Any]]] ()
        var arrayAllTags = [[String: Any]]()
        var isEdit = false
        var isShowDropDown = false
        var address: ShippingAddress?
        var txtFieldEmpty = UITextField()
        var productId: Int? {
            didSet {
                self.isEdit = true
            }
        }
        var product: Product?
        var commission: CGFloat = 0.0
        weak var delegate: AddItemViewDelegate?
        //let dropDown = DropDownTable(frame: .zero, style: .plain)
        let dropDown = DropDownView(frame: .zero)
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.setup()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            
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
        
        
        // MARK: - Private functions
        private func setup() {
            //self.view.backgroundColor = UIColor.colorWithRGBA(redC: 240, greenC: 244, blueC: 248, alfa: 0.5)
            self.recheckVM()
            self.registerNib()
            self.getDataSource()
            self.navigationController?.presentTransparentNavigationBar()
            self.addLeftButton(image: #imageLiteral(resourceName: "cross"), target: self, action: #selector(tapCross))
            self.txtFieldEmpty.inputAccessoryView = self.viewKeyword
            txtFieldEmpty.frame = CGRect.zero
            txtFieldEmpty.autocorrectionType = .no
            txtFieldKeyword.autocorrectionType = .no
            self.view.addSubview(txtFieldEmpty)
            self.viewKeyword.makeLayer(color: .lightGray, boarderWidth: 1.0, round: 0)
            
            if isEdit {
                self.lblHeading.text = "Edit item".localize()
            }
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: NSNotification.Name.UIKeyboardWillShow,
                object: nil
            )
            
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillShow),
                name: NSNotification.Name.UIKeyboardWillHide,
                object: nil
            )
            self.view.addSubview(self.dropDown)
            self.requestToAllTag()
            //self.dropDown.addShadow(ofColor: .black, radius: 5, offset: .zero, opacity: 5.0)
            self.dropDown.makeLayer(color: .lightGray, boarderWidth: 1.0, round: 4)
            self.dropDown.dropDownTable.didSelectRow = { [weak self] (_ tag: String)  in
                guard let strongSelf = self else { return }
                strongSelf.addTag(tag)
            }
            self.requestGetSellerCommission()
        }
        
        
        func showDropDown() {
            if self.arrayAllTags.count > 0 {
                self.dropDown.dropDownTable.configureList(array: self.arrayAllTags)
            }
        }
        
        func hideTable() {
            self.dropDown.frame = .zero
        }
        
        func addTag(_ tagStr: String) {
            self.isShowDropDown = false
            self.view.endEditing(true)
            self.txtFieldKeyword.text = ""
            self.txtFieldKeyword.resignFirstResponder()
            self.txtFieldEmpty.resignFirstResponder()
            self.dropDown.isHidden = true
            self.hideTable()
            if tagStr.isEmpty {
                return
            }
            if var tag =  self.arraryModel[4][0] as? [String: Any], var array = tag[Constant.keys.kTags] as? [String] {
                let finaTag = "#\(tagStr)"
                array.append(finaTag)
                tag[Constant.keys.kTags] = array
                self.arraryModel[4][0] = tag
                self.tblAddItem.reloadData()
            }
        }
        
        @objc func keyboardHide(_ notification: Notification) {
            self.hideTable()
        }
        
        
        
        @objc func keyboardWillShow(_ notification: Notification) {
            if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                if self.isShowDropDown, keyboardHeight > 0.0 {
                    //Threads.performTaskAfterDealy(0.1) {
                    var frame = self.view.frame
                    frame.origin.x = 16
                    frame.origin.y = 80
                    frame.size.width = Constant.screenWidth - 32
                    frame.size.height = (frame.size.height - 120 - keyboardHeight)
                    self.dropDown.frame = frame
                    self.dropDown.updateTableFrame()
                    if self.arrayAllTags.count > 0 {
                        self.dropDown.dropDownTable.configureList(array: self.arrayAllTags)
                    }
                    self.dropDown.isHidden = false
                    self.dropDown.dropDownTable.reloadData()
                    //}
                }
            }
        }
        
        private func recheckVM() {
            if self.viewModel == nil {
                self.viewModel = AddItemVM()
            }
        }
        
        private func getDataSource() {
            if isEdit {
                self.requestToProductDetailForEdit()
            }
            if let array = self.viewModel?.getDataSource(productDetail: self.product, commission: self.commission) {
                self.arraryModel.removeAll()
                self.arraryModel.append(contentsOf: array)
            }
            self.tblAddItem.reloadData()
        }
        
        private func registerNib() {
            self.tblAddItem.register(ItemNameCell.self)
            self.tblAddItem.register(AddItemCell.self)
            self.tblAddItem.register(ItemDescCell.self)
            self.tblAddItem.register(ItemPhotoCell.self)
            self.tblAddItem.register(TagsCell.self)
            self.tblAddItem.register(PromoteCell.self)
            self.tblAddItem.register(SaveItemCell.self)
            self.tblAddItem.register(QuantityCell.self)
            self.tblAddItem.register(LocationCell.self)
        }
        
        // IBAction functions
        @objc func tapCross() {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.navigationController?.popViewController(animated: true)
        }
        
        // MARK: - API Methods
        func requestToProductDetailForEdit() {
            guard let productID = self.productId else { return }
            self.viewModel?.requestGetProductDetail(productId: productID, completion: { [weak self] (product, isDeleted) in
                guard let strongSelf = self else { return }
                //            if isDeleted {
                //                strongSelf.itemDeleted()
                //                return
                //            }
                strongSelf.product = product
                if let array = strongSelf.viewModel?.getDataSource(productDetail: strongSelf.product, commission: strongSelf.commission) {
                    strongSelf.arraryModel.removeAll()
                    strongSelf.arraryModel.append(contentsOf: array)
                }
                strongSelf.tblAddItem.reloadData()
            })
        }
        
        func requestToAllTag() {
            self.viewModel?.getAllKeyword(text: "", completion: {[weak self] (array) in
                guard let strongSelf = self else { return }
                strongSelf.arrayAllTags.append(contentsOf: array)
                strongSelf.showDropDown()
            })
        }
        
        func requestGetSellerCommission() {
            self.viewModel?.requestGetSellerComission(completion: {[weak self] (commision) in
                guard let strongSelf = self else { return }
                strongSelf.commission = commision
                strongSelf.getDataSource()
            })
        }
        
        func uploadImages(image: UIImage, indexPath: IndexPath) {
            
            guard let compressedImage = image.manageOrientation(maxResolution: 720.0, quality: .high) else {
                return
            }
            
            if var array = self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] as? [[String: Any]] {
                array.append([Constant.keys.kImage : compressedImage, Constant.keys.kImageStatus: ImageStatus.uploading])
                self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] = array
                self.tblAddItem.reloadData()
                self.uploadImageToS3(image: compressedImage, imageIndex: (array.count-1), indexPath: indexPath)
            }
        }
        
        func uploadImageToS3(image: UIImage, imageIndex: Int, indexPath: IndexPath) {
            
            TAS3Manager.sharedInst.uploadImage(image, .other, nil) { [weak self] (response, error) in
                guard let strongSelf = self else { return }
                if var finalArray = strongSelf.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] as? [[String: Any]] {
                    var dict = finalArray[imageIndex]
                    if let imageUrl = response as? String {
                        dict[Constant.keys.kImageUrl] = imageUrl
                        dict[Constant.keys.kImageStatus] = ImageStatus.uploaded
                    } else {
                        dict[Constant.keys.kImageStatus] = ImageStatus.uploadFailed
                    }
                    finalArray[imageIndex] = dict
                    strongSelf.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] = finalArray
                    Threads.performTaskInMainQueue {
                        strongSelf.tblAddItem.reloadData()
                    }
                }
            }
        }
        
        // Public functions
        func addImage(indexPath: IndexPath)  {
            self.view.endEditing(true)
            
            // Internet check
            if !Loader.isReachabile() {
                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: ConstantTextsApi.noInternetConnection.localizedString)
                return
            }
            
            // Maximum image condition check
            if let array = self.arraryModel[indexPath.section][indexPath.row][Constant.keys.kImageArray] as? [[String: Any]], array.count >= Constant.maxPhotoCount {
                print("array count: \(array.count)")
                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "You can upload maximum 10 images".localize())
                return
            }
            
            DeviceSettings.checklibrarySettings(self) { (success) in
                if success {
                    ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, completion: { [weak self]
                        image in
                        guard let strongSelf = self else { return }
                        strongSelf.uploadImages(image: image, indexPath: indexPath)
                        //strongSelf.profileImage = image
                        //strongSelf.tblViewProfileInfo.reloadData()
                        //strongSelf.uploadImage(isProfile: true, image: image)
                    })
                }
            }
        }
        
        func updateCategory(category: CategoryModel, subCate: SubCategoryModel) {
            //let indexPath = self.indexPath, indexPath.section == 1, indexPath.row == 0,
            // Category data
            var dict = self.arraryModel[1][0]
            if let catTitle = category.name, let subCatTitle = subCate.name, let catId = category.id, let subCatId = subCate.id {
                dict[Constant.keys.kValue] = "\(catTitle) > \(subCatTitle)"
                dict[Constant.keys.kCategoryId] = catId as Int
                dict[Constant.keys.kSubCategoryId] = subCatId as Int
                self.arraryModel[1][0] = dict
                self.tblAddItem.reloadData()
            }
        }
        
        func updateAddress(shippingAdd: ShippingAddress)  {
            self.address = shippingAdd
            var dict = self.arraryModel[3][1]
            dict[Constant.keys.kValue] = shippingAdd.getDisplayAddress()
            self.arraryModel[3][1] = dict
            self.tblAddItem.reloadData()
        }
        
        
        func processData(actionType: ActionType) {
            
            var itemName = ""; var arrayImageUrl = [String](); var desc = ""; var catId = ""; var subCat = ""
            var itemConditon = ""; var quantity = ""; var price = ""; var shipping = ""; var location = ""; var imageUploading = false
            var tagsArray = [String]();
            
            
            // Name
            if let dict = self.arraryModel[0][0] as? [String: Any], let name = dict[Constant.keys.kValue] as? String {
                itemName = name
            }
            // Image array
            if let array = arraryModel[0][1][Constant.keys.kImageArray] as? [[String: Any]] {
                for dict in array {
                    if let imageUrl = dict[Constant.keys.kImageUrl] as? String {
                        arrayImageUrl.append(imageUrl)
                    }
                    if let imageUploadStatus = dict[Constant.keys.kImageStatus] as? ImageStatus, imageUploadStatus == ImageStatus.uploading {
                        imageUploading = true
                    }
                }
            }
            
            // Desc
            if let dict = self.arraryModel[0][2] as? [String: Any], let descValue = dict[Constant.keys.kValue] as? String {
                desc = descValue
            }
            
            
            // Category
            if let dict = self.arraryModel[1][0] as? [String: Any], let subCatIdValue = dict[Constant.keys.kSubCategoryId] as? Int {
                subCat = "\(subCatIdValue)"
            }
            
            // Item condition
            if let dict = self.arraryModel[1][1] as? [String: Any], let condition = dict[Constant.keys.kValue] as? String {
                if condition == ItemCondition.new.rawValue {
                    itemConditon = "1"
                } else if condition == ItemCondition.used.rawValue {
                    itemConditon = "2"
                } else {
                    itemConditon = ""
                }
            }
            
            // Item quantity
            if let dict = self.arraryModel[1][2] as? [String: Any], let quantityV = dict[Constant.keys.kValue] as? Int {
                
                quantity = "\(quantityV)"
            }
            
            // Price
            if let dict = self.arraryModel[2][0] as? [String: Any], let priceValue = dict[Constant.keys.kValue] as? String {
                price = priceValue
            }
            
            // Shipping
            if let dict = self.arraryModel[3][0] as? [String: Any], let shipingValue = dict[Constant.keys.kValue] as? String {
                //price = priceValue
                switch shipingValue {
                case "Buyer will pay": shipping = "1"
                case "I will pay": shipping = "2"
                case "Self pickup": shipping = "3"
                case "I will deliver": shipping = "4"
                default: break
                    
                }
            }
            
            if let tag =  self.arraryModel[4][0] as? [String: Any], var array = tag[Constant.keys.kTags] as? [String], array.count > 0 {
                tagsArray.append(contentsOf: array)
            }
            
            let sellerId = Defaults[.sellerId]
            
            var isDraft = "0"
            if actionType == .saveAsDraft {
                isDraft = "1"
            }
            
            // Location
            if let dict = self.arraryModel[3][1] as? [String: Any], let locationV = dict[Constant.keys.kValue] as? String {
                location = locationV
            }
            
            
            if itemName.isEmpty {
                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter the item name.")
                return
            }
            
            if actionType != ActionType.saveAsDraft {
                
                if imageUploading {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please wait, image is uploading.")
                    return
                }
                
                if arrayImageUrl.count == 0 {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please select images")
                    return
                }
                
                if subCat.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please choose category")
                    return
                }
                
                if price.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter price")
                    return
                }
                
                if itemConditon.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please entery item condition")
                    return
                }
                
                if shipping.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please choose shipping type")
                    return
                }
                
                if desc.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter description")
                    return
                }
                if location.isEmpty {
                    Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Please enter Location")
                    return
                }
            }
            
            
            
            var city = ""; var blockNo = ""; var streeNo = ""; var avenueNo = "";
            var buildingNO = ""; var packiNO = "";
            if let shipingAddress = self.address {
                city = shipingAddress.city ?? ""
                blockNo = shipingAddress.blockNo ?? ""
                streeNo = shipingAddress.street ?? ""
                avenueNo = shipingAddress.avenueNo ?? ""
                buildingNO = shipingAddress.buildingNo ?? ""
                packiNO = shipingAddress.paciNo ?? ""
            } else {
                city = product?.city ?? ""
                blockNo = product?.blockNo ?? ""
                streeNo = product?.street ?? ""
                avenueNo = product?.avenueNo ?? ""
                buildingNO = product?.buildingNo ?? ""
                packiNO = product?.paciNo ?? ""
            }
            
            var param: [String: AnyObject] = ["itemName": itemName as AnyObject,
                                              "categoryId": subCat as AnyObject,
                                              "sellerId": sellerId as AnyObject,
                                              "price": price as AnyObject,
                                              "quantity": quantity as AnyObject,
                                              "description": desc as AnyObject,
                                              "condition": itemConditon as AnyObject,
                                              "model": "" as AnyObject,
                                              "brand": "" as AnyObject,
                                              "color": "" as AnyObject,
                                              "shipping": shipping as AnyObject,
                                              "country": "Kuwait" as AnyObject,
                                              "city": city as AnyObject,
                                              "blockNo": blockNo as AnyObject,
                                              "street": streeNo as AnyObject,
                                              "avenueNo": avenueNo as AnyObject,
                                              "buildingNo": buildingNO as AnyObject,
                                              "paciNo": packiNO as AnyObject,
                                              "isDrafted": isDraft as AnyObject,
                                              "imageUrl": arrayImageUrl as AnyObject,
                                              "tags": tagsArray as AnyObject,
                                              ]
            
            
            if isEdit, let productDetail = self.product, let itemId = productDetail.itemId,let sellerId = productDetail.sellerId {
                param["itemId"] = itemId as AnyObject
                param["sellerId"] = sellerId as AnyObject
                if let isLike = productDetail.isLike, isLike {
                    param["isLike"] = "1" as AnyObject
                } else {
                    param["isLike"] = "0" as AnyObject
                }
                param["status"] = ProductStatus.pending.rawValue as AnyObject
                self.viewModel?.requestApiToUpdateAddItem(param: param, completions: { [weak self] (success) in
                    guard let strongSelf = self else { return }
                    if success, let navC = strongSelf.navigationController {
                        if let delegate = strongSelf.delegate {
                            delegate.didTapSaveProduct()
                        }
                        Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Item is published successfully.".localize(), completeion_: { (success) in
                            let viewControllers: [UIViewController] = navC.viewControllers
                            for viewC in viewControllers {
                                if viewC is SellerProductListViewC {
                                    navC.popToViewController(viewC, animated: true)
                                }
                            }
                        })
                    }
                })
                return
            }
            
            self.viewModel?.requestApiToAddItem(param: param, completions: { _ in
                
            }, alertCallBack: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.navigationController?.popViewController(animated: true)
            })
            
            /*
             self.viewModel?.requestApiToAddItem(param: param, completions: { [weak self] (success) in
             guard let strongSelf = self else { return }
             if success {
             strongSelf.navigationController?.popViewController(animated: true)
             }
             })*/
        }
    }
    
    extension AddItemViewC: UITextFieldDelegate {
        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            //guard let delete = self.delegate else { return false }
            //delete.openKeyword()
            return true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            
            if string == " ", let text = textField.text, !text.isEmpty {
                self.addTag(text)
                return false
            }
            
            if let text = textField.text, let textRange = Range(range, in: text), textField == self.txtFieldKeyword {
                let finalText = text.replacingCharacters(in: textRange, with: string)
                self.dropDown.dropDownTable.updateSearch(finalText)
                //if finalText.trim().utf8.count > 0 {
                //    self.dropDown.updateSearch(finalText)
                //}
                
            }
            return true
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            self.view.endEditing(true)
            self.addTag("")
            return true
        }
        
    }
    
    
    
    
