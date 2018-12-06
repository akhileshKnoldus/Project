//
//  EditProfileViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/10/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import TPKeyboardAvoiding
import SwiftyUserDefaults
import CropViewController
import MobileCoreServices

class EditProfileViewC: BaseViewC {
    
    //MARK: - IBOutlets
    //@IBOutlet weak var tblViewEditProfile: UITableView!
    @IBOutlet weak var tblViewEditProfile: TPKeyboardAvoidingTableView!
    
    //MARK: - Variables
    var viewModel: EditProfileVModeling?
    var arrayData = [[String: Any]]()
    var coverImageStatus: ImageStatus = .empty
    var profileImageStatus: ImageStatus = .empty
    var isCircle = true

    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    //MARK: - Private Methods
    private func setup() {
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        if let array = self.viewModel?.getDataSource() {
            self.arrayData = array
            self.tblViewEditProfile.reloadData()
        }
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = EditProfileVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewEditProfile.separatorStyle = .none
        self.tblViewEditProfile.dataSource = self
        self.tblViewEditProfile.delegate = self
        self.tblViewEditProfile.tableFooterView = self.footerView()
    }
    
    private func registerCell() {
        self.tblViewEditProfile.register(ProfileCoverCell.self)
        self.tblViewEditProfile.register(EditNameCell.self)
        self.tblViewEditProfile.register(EditInformationCell.self)
        self.tblViewEditProfile.register(EditPhoneCell.self)
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
    
    func presentCircularCorpVC(image: UIImage, isCircle: Bool)  {
        let cropVC = CropViewController(croppingStyle: (isCircle ? .circular: .default), image: image)
        cropVC.delegate = self
        if  !isCircle {
            cropVC.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.preset4x3
        }
        self.present(cropVC, animated: false, completion: nil)
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
    
    private func selectProfileImage() {
        self.view.endEditing(true)
        self.prsentImagePickerOption()
        return
        DeviceSettings.checklibrarySettings(self) { (success) in
            if success {
                
                ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, allowEditing: false, completion: { [weak self]
                    image in
                    guard let strongSelf = self else { return }
                    strongSelf.presentCircularCorpVC(image: image, isCircle: true)
                    
                    /*
                    Threads.performTaskAfterDealy(0.2, {
                        var imageData = strongSelf.arrayData[0]
                        imageData[Constant.keys.kProfileImage] = image
                        strongSelf.arrayData[0] = imageData
                        strongSelf.tblViewEditProfile.reloadData()
                        strongSelf.uploadImage(image: image, isProfile: true)
                    })*/
                })
                
            }
        }
    }
    
    func selectCoverImage() {
        self.view.endEditing(true)
        self.prsentImagePickerOption()
        return
        DeviceSettings.checklibrarySettings(self) { (success) in
            if success {
                ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, allowEditing: false, completion: { [weak self]
                    image in
                    guard let strongSelf = self else { return }
                    strongSelf.presentCircularCorpVC(image: image, isCircle: false)
                    /*
                    guard let strongSelf = self else { return }
                    Threads.performTaskAfterDealy(0.2, {
                        var imageData = strongSelf.arrayData[0]
                        imageData[Constant.keys.kCoverImage] = image
                        strongSelf.arrayData[0] = imageData
                        print(imageData)
                        strongSelf.tblViewEditProfile.reloadData()
                        strongSelf.uploadImage(image: image, isProfile: false)
                    })*/
                    
                })
            }
        }
    }
    
    // MARK: - Public functions
    func updatePhone() {
        if let user = Defaults[.user], let mobileNumber = user.mobileNumber {
            var phoneData = self.arrayData[5]
            phoneData[Constant.keys.kValue] = mobileNumber
            self.arrayData[5] = phoneData
            self.tblViewEditProfile.reloadData()
        }
    }
    
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapUpdate() {
        self.view.endEditing(true)
        if self.coverImageStatus == .uploading || self.profileImageStatus == .uploading {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Image is uploading".localize())
            return
        }
        
        if let viewModel = self.viewModel, viewModel.validateData(self.arrayData) {
            viewModel.updateProfile(arrayData: self.arrayData, completion: {[weak self] (success) in
                if success, let strongSelf = self {
                    Alert.showOkGrayAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: "Profile updated successfully.".localize(), completeion_: { (success) in
                        strongSelf.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }
    }
    
    func footerView() -> UIView? {
        let height = 55.0 * Constant.htRation
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constant.screenWidth-30, height: height + 10))
        view.backgroundColor = .clear
        let button = AVButton(frame: CGRect(x: 0, y: 5, width: Constant.screenWidth-30, height: height))
        button.isButtonActive = true
        button.conrnerRadius = CGFloat(8.0)
        
        button.addTarget(self, action: #selector(tapUpdate), for: .touchUpInside)
        button.titleLabel?.font = UIFont.font(name: .SFProText, weight: .Medium, size: FontSize.size_15)
        button.localizeKey = "Update"
        view.addSubview(button)
        return view
    }
}

//MARK: - TableViewDataSourceAndDelegates
extension EditProfileViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getProfileCoverCell(indexPath, tableView: tableView)
        case 1:
            return getEditNameCell(indexPath, tableView: tableView)
        case 5:
            return getEditPhoneCell(indexPath, tableView: tableView)
        default:
            return getEditInformationCell(indexPath, tableView: tableView)
        }
    }
    
    
    
    private func getProfileCoverCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileCoverCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let imageData = self.arrayData[indexPath.row]
        //let profileImage = imageData[Constant.keys.kProfileImage] as? UIImage
        //let coverImage = imageData[Constant.keys.kCoverImage] as? UIImage
        //cell.configureView(profileImage: profileImage, coverImage: coverImage)
        //print(imageData)
        cell.configureEditProfileView(data: imageData, cvImgStatus: self.coverImageStatus, pfImgStatus: self.profileImageStatus)
        return cell
    }
    
    private func getEditNameCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: EditNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(data: self.arrayData[indexPath.row])
        return cell
    }
    
    private func getEditInformationCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: EditInformationCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(data: self.arrayData[indexPath.row], indexPath: indexPath)
        return cell
    }
    
    private func getEditPhoneCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: EditPhoneCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureCell(data: self.arrayData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
        case 5:
            return 65.0
        default:
            return 65.0
        }
    }
}

//MARK: - ProfileCoverCellDelegate
extension EditProfileViewC: ProfileCoverCellDelegate {
    
    func profileImageDidTap() {
        self.isCircle = true
        self.selectProfileImage()
    }
    
    func coverImageDidTap() {
        self.isCircle = false
        self.selectCoverImage()
    }
}

//MARK: - EditNameCellDelegate
extension EditProfileViewC: EditNameCellDelegate {
    func textChanged(_ text: String, cell: UITableViewCell) {
        if let index = self.tblViewEditProfile.indexPath(for: cell) {
            self.arrayData[index.row][Constant.keys.kValue] = text
        }
    }
    
    func tapNexKeyboard(cell: UITableViewCell) {
        if var indexPath = self.tblViewEditProfile.indexPath(for: cell) {
            indexPath.row += 1
            if let cell = self.tblViewEditProfile.cellForRow(at: indexPath) as? EditInformationCell, indexPath.row != 4 {
                cell.txtFieldInfo.becomeFirstResponder()
            } else {
                self.view.endEditing(true)
            }
        }
    }
    
    func nameChanged(text: String, isFirstName: Bool) {
        if isFirstName {
            self.arrayData[1][Constant.keys.kFirstNameV] = text
        } else {
            self.arrayData[1][Constant.keys.kLastNameV] = text
        }
    }
}

//MARK: - EditInformationCellDelegate
//extension EditProfileViewC: EditInformationCellDelegate {
//    func informationChanged(text: String, cell: EditInformationCell) {
//        if let index = self.tblViewEditProfile.indexPath(for: cell) {
//            self.arrayData[index.row][Constant.keys.kValue] = text
//        }
//    }
//}

//MARK: - EditPhoneCellDelegate
extension EditProfileViewC: EditPhoneCellDelegate {
    func phoneNumberChanged(_ phone: String) {
        self.arrayData[5][Constant.keys.kValue] = phone
    }
    
    // Change mobile number
    func changeButtonTapped(_ cell: EditPhoneCell) {
        if let verifyPhone = DIConfigurator.sharedInst().getVerifyPhone() {
            verifyPhone.hidesBottomBarWhenPushed = true
            verifyPhone.isUpdatePhone = true
            self.navigationController?.pushViewController(verifyPhone, animated: true)
        }
    }
}

extension EditProfileViewC: CropViewControllerDelegate {
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

extension EditProfileViewC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = (info[UIImagePickerControllerOriginalImage] as? UIImage) else { return }
        
        
        let cropController = CropViewController(croppingStyle: (isCircle ? .circular: .default), image: image)
        cropController.aspectRatioPickerButtonHidden = true
        cropController.delegate = self
        if  !isCircle {
            cropController.aspectRatioPreset = TOCropViewControllerAspectRatioPreset.preset3x2
            cropController.aspectRatioLockEnabled = true
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
