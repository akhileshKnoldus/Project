//
//  SellerEditProfileViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/29/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import CropViewController
import MobileCoreServices

protocol SellerEditProfileDelegate: class {
    func reloadProfileView()
}

class SellerEditProfileViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var lblEditStore: AVLabel!
    @IBOutlet weak var tblViewEditProfile: TPKeyboardAvoidingTableView!
    
    
    //MARK: - Variables
    var viewModel: SellerEditProfileVModeling?
    var arrayData = [[String: Any]]()
    var seller: SellerDetail?
    var coverImageStatus: ImageStatus = .empty
    var profileImageStatus: ImageStatus = .empty
    var address: ShippingAddress?
    var typeSeller: sellerType = .individual
    var delegate: SellerEditProfileDelegate?
    var isCircle = true
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        self.setupView()
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = SellerEditProfileVM()
        }
    }
    
    private func setupView() {
        if let sellerInfo = self.seller, let type = sellerInfo.sellerType {
            switch type {
            case sellerType.individual.rawValue:
                self.typeSeller = .individual
                self.lblEditStore.text = "Edit account".localize()
                if let array = self.viewModel?.getIndividualDataSource(seller: seller) {
                    self.arrayData = array
                    self.tblViewEditProfile.reloadData()
                }
            case sellerType.business.rawValue:
                self.typeSeller = .business
                self.lblEditStore.text = "Edit store".localize()
                if let array = self.viewModel?.getStoreDataSource(seller: seller) {
                    self.arrayData = array
                    self.tblViewEditProfile.reloadData()
                }
            default:
                return
            }
        }
    }
    
    private func setupTableStyle() {
        self.tblViewEditProfile.separatorStyle = .none
        self.tblViewEditProfile.dataSource = self
        self.tblViewEditProfile.delegate = self
    }
    
    private func registerCell() {
        self.tblViewEditProfile.register(ProfileCoverCell.self)
        self.tblViewEditProfile.register(ProfileNameCell.self)
        self.tblViewEditProfile.register(ProfileDescriptionCell.self)
        self.tblViewEditProfile.register(StoreAddressTableCell.self)
        self.tblViewEditProfile.register(AddNewAddressTableCell.self)
        self.tblViewEditProfile.register(SaveButtonTableCell.self)
    }

    private func uploadImage(image: UIImage, isProfile: Bool) {
        
        if isProfile {
            self.profileImageStatus = .uploading
        } else {
            self.coverImageStatus = .uploading
        }
        self.tblViewEditProfile.reloadData()
        //Loader.showLoader()
        TAS3Manager.sharedInst.uploadImage(image, .other, nil) { [weak self] (imageResponse, error) in
            //Loader.hideLoader()
            guard let strongSelf = self else { return }
            if let imageUlr = imageResponse as? String {
                if isProfile {
                    strongSelf.profileImageStatus = .uploaded
                } else {
                    strongSelf.coverImageStatus = .uploaded
                }
                var imageData = strongSelf.arrayData[0]
                if isProfile {
                    imageData[Constant.keys.kProfileImageUrl] = imageUlr
                } else {
                    imageData[Constant.keys.kCoverImageUrl] = imageUlr
                }
                strongSelf.arrayData[0] = imageData
            } else {
                if isProfile {
                    strongSelf.profileImageStatus = .uploadFailed
                } else {
                    strongSelf.coverImageStatus = .uploadFailed
                }
            }
            
            Threads.performTaskInMainQueue {
                strongSelf.tblViewEditProfile.reloadData()
            }
        }
    }
    
    func prsentImagePickerOption() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionSelectCamera = UIAlertAction(title: "Camera".localize(), style: .default, handler: {
            UIAlertAction in
            imgPicker.sourceType = .camera
            self.present(imgPicker, animated: true, completion: nil)
        })
        let actionSelectGallery = UIAlertAction(title: "Gallery".localize(), style: .default, handler: {
            UIAlertAction in
            imgPicker.sourceType = .photoLibrary
            self.present(imgPicker, animated: true, completion: nil)
            
        })
        let actionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionSelectCamera)
        actionSheet.addAction(actionSelectGallery)
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func selectProfileImage() {
        
        self.view.endEditing(true)
        self.isCircle = true
        self.prsentImagePickerOption()
        return
        
        DeviceSettings.checklibrarySettings(self) { (success) in
            if success {
                ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, completion: { [weak self]
                    image in
                    guard let strongSelf = self else { return }
                    Threads.performTaskAfterDealy(0.2, {
                        var imageData = strongSelf.arrayData[0]
                        imageData[Constant.keys.kProfileImage] = image
                        strongSelf.arrayData[0] = imageData
                        strongSelf.tblViewEditProfile.reloadData()
                        strongSelf.uploadImage(image: image, isProfile: true)
                    })
                })
            }
        }
    }
    
    func selectCoverImage() {
        self.view.endEditing(true)
        self.isCircle = false
        self.prsentImagePickerOption()
        return
            
        DeviceSettings.checklibrarySettings(self) { (success) in
            if success {
                ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, completion: { [weak self]
                    image in
                    guard let strongSelf = self else { return }
                    Threads.performTaskAfterDealy(0.2, {
                        var imageData = strongSelf.arrayData[0]
                        imageData[Constant.keys.kCoverImage] = image
                        strongSelf.arrayData[0] = imageData
                        print(imageData)
                        strongSelf.tblViewEditProfile.reloadData()
                        strongSelf.uploadImage(image: image, isProfile: false)
                    })
                    
                })
            }
        }
    }
    
    @objc func tapUpdate() {
        
        if self.coverImageStatus == .uploading || self.profileImageStatus == .uploading {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Image is uploading".localize())
            return
        }
        
//        if let viewModel = self.viewModel, viewModel.validateData(self.arrayData) {
//            viewModel.updateProfile(arrayData: self.arrayData, completion: {[weak self] (success) in
//                if success, let strongSelf = self {
//                    strongSelf.navigationController?.popViewController(animated: true)
//                }
//            })
//        }
    }
    
    func moveToAddAddressViewC() {
        if let addAddressViewC = DIConfigurator.sharedInst().getAddAddressVC() {
            self.navigationController?.pushViewController(addAddressViewC, animated: true)
        }
    }
    
    func moveToAddressListingViewC() {
        if let addressListViewC = DIConfigurator.sharedInst().getAddressList() {
            self.navigationController?.pushViewController(addressListViewC, animated: true)
        }
    }
    
    func updateAddress(shippingAdd: ShippingAddress)  {
        self.address = shippingAdd
        var sellerAddress = ""
        if let city = address?.city, !city.isEmpty {
            sellerAddress = "City".localize() + ":" + city
        }
        if let block = address?.blockNo, !block.isEmpty {
            sellerAddress = sellerAddress + ", " + "Block".localize() + ":" + block
        }
        if let street = address?.street, !street.isEmpty {
            sellerAddress = sellerAddress + ", " + "Street".localize() + ":" + street
        }
        if let avenue = address?.avenueNo, !avenue.isEmpty {
            sellerAddress = sellerAddress + ", " + "Avenue No.".localize() + ":" + avenue
        }
        if let building = address?.buildingNo, !building.isEmpty {
            sellerAddress = sellerAddress + ", " + "Building No.".localize() + ":" + building
        }
        
        if self.typeSeller == .individual {
            self.arrayData[2][Constant.keys.kValue] = sellerAddress
        } else {
            self.arrayData[3][Constant.keys.kValue] = sellerAddress
        }
        
        self.tblViewEditProfile.reloadData()
    }
    
    func requestEditStore() {
        if self.coverImageStatus == .uploading || self.profileImageStatus == .uploading {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Image is uploading".localize())
            return
        }
        if let viewModel = self.viewModel, viewModel.validateDataForStore(self.arrayData) {
            viewModel.updateStoreProfile(arrayData: self.arrayData, address: self.address, seller: self.seller, completion: {[weak self] (success) in
                if success, let strongSelf = self {
                    Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Profile updated successfully.".localize(), completeion_: { (success) in
                        if let delegate = strongSelf.delegate {
                            delegate.reloadProfileView()
                        }
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    func requestEditIndividualProfile() {
        if self.coverImageStatus == .uploading || self.profileImageStatus == .uploading {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Image is uploading".localize())
            return
        }
        if let viewModel = self.viewModel, viewModel.validateDataForIndividual(self.arrayData) {
            viewModel.updateIndividualSellerProfile(arrayData: self.arrayData, address: self.address, seller: self.seller, completion: {[weak self] (success) in
                if success, let strongSelf = self {
                    Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Profile updated successfully.".localize(), completeion_: { (success) in
                        if let delegate = strongSelf.delegate {
                            delegate.reloadProfileView()
                        }
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SellerEditProfileViewC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: false, completion: nil)
        Threads.performTaskAfterDealy(0.2, {
            var imageData = self.arrayData[0]
            imageData[Constant.keys.kCoverImage] = image
            self.arrayData[0] = imageData
            print(imageData)
            self.tblViewEditProfile.reloadData()
            self.uploadImage(image: image, isProfile: false)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false, completion: nil)
        Threads.performTaskAfterDealy(0.2, {
            var imageData = self.arrayData[0]
            imageData[Constant.keys.kProfileImage] = image
            self.arrayData[0] = imageData
            self.tblViewEditProfile.reloadData()
            self.uploadImage(image: image, isProfile: true)
        })
    }
}


extension SellerEditProfileViewC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        let cropController = CropViewController(croppingStyle: (isCircle ? .circular: .default), image: image)
        cropController.aspectRatioPickerButtonHidden = true
        cropController.delegate = self
        if  !isCircle {
            cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.preset3x2
            cropController.aspectRatioLockEnabled = true
            cropController.resetAspectRatioEnabled = false
        }
        //self.present(cropVC, animated: false, completion: nil)
        if isCircle {
            if picker.sourceType == .camera {
                picker.dismiss(animated: true, completion: {
                    self.present(cropController, animated: true, completion: nil)
                })
            } else {
                picker.pushViewController(cropController, animated: true)
            }
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
    }
}
