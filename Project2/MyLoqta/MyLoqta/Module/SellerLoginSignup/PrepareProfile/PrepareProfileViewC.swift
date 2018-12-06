//
//  PrepareBusinessProfileViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/6/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit
import CropViewController
import MobileCoreServices

class PrepareProfileViewC: BaseViewC {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: AVLabel!
    @IBOutlet weak var tblViewProfileInfo: UITableView!
    @IBOutlet weak var btnStartSelling: AVButton!
    @IBOutlet weak var btnBack: UIButton!
    
    //MARK:- Variables
    var viewModel: PrepareProfileVModeling?
    var sellerType: sellerType = .business
    var bankId: Int = 0
    var ibanNumber: String = ""
    var coverImage: UIImage?
    var profileImage: UIImage?
    var imageArray = [String]()
    var coverImageUrl = ""
    var coverImageStatus: ImageStatus = .empty
    
    var profileImageUrl = ""
    var profileImageStatus: ImageStatus = .empty
    var strName = ""
    var strDesc = ""
    var arrayDocuments: [[String: Any]] = [[:]]
    var isCircle = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Methods
    
    private func setup() {
        self.lblTitle.text = sellerType == .individual ? "Individual account".localize() : "Business account".localize()
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        self.btnStartSelling.isButtonActive = true
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = PrepareProfileVM()
        }
    }
    
    private func setupTableStyle() {
        self.tblViewProfileInfo.separatorStyle = .none
        self.tblViewProfileInfo.dataSource = self
        self.tblViewProfileInfo.delegate = self
    }
    
    private func registerCell() {
        self.tblViewProfileInfo.register(PrepareAccountDescCell.self)
        self.tblViewProfileInfo.register(ProfileCoverCell.self)
        self.tblViewProfileInfo.register(ProfileNameCell.self)
        self.tblViewProfileInfo.register(ProfileDescriptionCell.self)
    }
    
    private func uploadImage(isProfile: Bool, image: UIImage) {
        
        //Loader.showLoader()
        if isProfile {
            self.profileImageStatus = .uploading
        } else {
            self.coverImageStatus = .uploading
        }
        self.tblViewProfileInfo.reloadData()
        TAS3Manager.sharedInst.uploadImage(image, .other, nil) { [weak self] (s3ImageUrl, error) in
            //Loader.hideLoader()
            guard let strongSelf = self else { return }
            if let imageUrl = s3ImageUrl as? String {
                if isProfile {
                    strongSelf.profileImageUrl = imageUrl
                    strongSelf.profileImageStatus = .uploaded
                } else {
                    strongSelf.coverImageUrl = imageUrl
                    strongSelf.coverImageStatus = .uploaded
                }
            } else {
                if isProfile {
                    strongSelf.profileImageStatus = .uploadFailed
                } else {
                    strongSelf.coverImageStatus = .uploadFailed
                }
            }
            Threads.performTaskInMainQueue {
                strongSelf.tblViewProfileInfo.reloadData()
            }
        }
    }// 8010482814
    
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
                    strongSelf.profileImage = image
                    strongSelf.tblViewProfileInfo.reloadData()
                    strongSelf.uploadImage(isProfile: true, image: image)
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
                    strongSelf.coverImage = image
                    strongSelf.tblViewProfileInfo.reloadData()
                    strongSelf.uploadImage(isProfile: false, image: image)
                })
            }
        }
    }
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapStartSelling(_ sender: UIButton) {
        
        if self.coverImageStatus == .uploading || self.profileImageStatus == .uploading {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: "Image is uploading".localize())
            return
        }
        
        
        if let viewModel = self.viewModel, viewModel.validateData(strName: self.strName, strDesc: self.strDesc, coverImageUrl: self.coverImageUrl, profileImageUrl: self.profileImageUrl, sellerType: sellerType) {
            
            self.viewModel?.requestToBecomeSeller(arrayDocuments, sellerType: sellerType, bankId: bankId, ibanNumber: ibanNumber, profileImage: profileImageUrl, coverImage: coverImageUrl, storeName: strName, storeDesc: strDesc, completion: { (success) in
                AppDelegate.delegate.showHome()
                self.tabBarController?.selectedIndex = 3
            })
        }
    }
}

extension PrepareProfileViewC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerType == .individual ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return getProfileHeaderCell(indexPath, tableView: tableView)
        case 1:
            return getProfileCoverCell(indexPath, tableView: tableView)
        case 2:
            return sellerType == .individual ? getProfileDescriptionCell(indexPath, tableView: tableView) : getProfileNameCell(indexPath, tableView: tableView)
        default:
            return getProfileDescriptionCell(indexPath, tableView: tableView)
        }
    }
    
    private func getProfileHeaderCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: PrepareAccountDescCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.lblHeader.text = sellerType == .individual ? "Prepare your account".localize() : "Prepare your store".localize()
        return cell
    }
    
    private func getProfileCoverCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileCoverCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configureView(profileImage: profileImage, coverImage: coverImage, cvImgStatus: self.coverImageStatus, pfImgStatus: self.profileImageStatus)
        return cell
    }
    
    private func getProfileNameCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileNameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    private func getProfileDescriptionCell(_ indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let cell: ProfileDescriptionCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.lblTitle.text = sellerType == .individual ? "Few words about you".localize() : "About store".localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 150.0
        case 1:
            return 200.0
        case 2:
            return sellerType == .individual ? 90.0 : 65.0
        default:
            return 90.0
        }
    }
}

extension PrepareProfileViewC: ProfileCoverCellDelegate {
    func profileImageDidTap() {
        self.view.endEditing(true)
        self.selectProfileImage()
    }
    
    func coverImageDidTap() {
        self.view.endEditing(true)
        self.selectCoverImage()
    }
}

extension PrepareProfileViewC: ProfileNameCellDelegate {
    func textChanged(_ text: String) {
        self.strName = text
    }
}

extension PrepareProfileViewC: ProfileDescriptionCellDelegate {
    func textDidChange(_ text: String) {
        self.strDesc = text
    }
}

extension PrepareProfileViewC: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: false, completion: nil)
        Threads.performTaskAfterDealy(0.2, {
            self.coverImage = image
            self.tblViewProfileInfo.reloadData()
            self.uploadImage(isProfile: false, image: image)
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: false, completion: nil)
        Threads.performTaskAfterDealy(0.2, {
            self.profileImage = image
            self.tblViewProfileInfo.reloadData()
            self.uploadImage(isProfile: true, image: image)
        })
        
    }
}

extension PrepareProfileViewC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
