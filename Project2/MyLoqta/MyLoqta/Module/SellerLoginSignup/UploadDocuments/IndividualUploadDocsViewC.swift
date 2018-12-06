//
//  IndividualUploadDocsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class IndividualUploadDocsViewC: BaseViewC {

    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTakePhotos: UILabel!
    @IBOutlet weak var lblUploadDesc: UILabel!
    @IBOutlet weak var tblViewDocs: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: AVButton!
    
    //MARK: - Variables
    var viewModel: IndividualUploadDocsVModeling?
    var dataSource: [[String: Any?]] = [[:]]
    var arrayDocuments = [[String: Any]]()
    
    //MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - PrivateMethods
    
    private func setup() {
        self.recheckVM()
        self.registerCell()
        self.setupTableStyle()
        self.setupDataSource()
        self.tblViewDocs.reloadData()
        self.btnNext.isButtonActive = false
    }
    
    private func recheckVM() {
        if self.viewModel == nil {
            self.viewModel = IndividualUploadDocsVM()
        }
    }
    
    private func setupDataSource() {
        if let dataSource = self.viewModel?.getDataSource() {
            self.dataSource = dataSource
        }
    }
    
    private func setupTableStyle() {
        self.tblViewDocs.separatorStyle = .none
        self.tblViewDocs.dataSource = self
        self.tblViewDocs.delegate = self
    }
    
    private func registerCell() {
        self.tblViewDocs.register(UploadDocumentsCell.self)
    }
    
    private func insertImage(image: UIImage, atIndex: Int) {
        var data = self.dataSource[atIndex]
        data["documentImage"] = image
        data[Constant.keys.kImageStatus] = ImageStatus.uploading
        self.dataSource[atIndex] = data
        self.tblViewDocs.reloadData()
        //Loader.showLoader()
        TAS3Manager.sharedInst.uploadImage(image, .other, nil) {[weak self] (response, error) in
            //Loader.hideLoader()
            guard let strongSelf = self else { return }
            if let imageUrl = response as? String {
                data["imageUrl"] = imageUrl
                data[Constant.keys.kImageStatus] = ImageStatus.uploaded
                strongSelf.dataSource[atIndex] = data
                strongSelf.addToDocumentsArray(index: atIndex, imageUrl: imageUrl)
                print("array is: \(strongSelf.dataSource)")
            } else {
                data[Constant.keys.kImageStatus] = ImageStatus.uploadFailed
                strongSelf.dataSource[atIndex] = data
            }
            Threads.performTaskInMainQueue {
                strongSelf.tblViewDocs.reloadData()
                strongSelf.checkNextButton()
            }
            
        }
    }
    
    private func removeImage(atIndex: Int) {
        var data = self.dataSource[atIndex]
        data["documentImage"] = nil
        data["imageUrl"] = ""
        data[Constant.keys.kImageStatus] = ImageStatus.empty
        self.dataSource[atIndex] = data
        self.tblViewDocs.reloadData()
    }
    
    private func addToDocumentsArray(index: Int, imageUrl: String) {
        let dict = ["title": index + 1 as AnyObject, "url": imageUrl as AnyObject]
        self.arrayDocuments.append(dict)
    }
    
    private func allImagesUploaded() -> Bool {
        for data in self.dataSource {
            if let imageUrl = data["imageUrl"] as? String, imageUrl == "" {
                return false
            }
        }
        return true
    }
    
    private func getImages() -> [String] {
        var arrayImages = [String]()
        for data in self.dataSource {
            if let imageUrl = data["imageUrl"] as? String {
                arrayImages.append(imageUrl)
            }
        }
        return arrayImages
    }
    
    //MARK: - PublicMethods
    
    func selectImage(index: Int) {
        
        if !Loader.isReachabile() {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: ConstantTextsApi.noInternetConnection.localizedString)
            return
        }
        
        DeviceSettings.checklibrarySettings(self) { (success) in
            if success {
                ImagePickerHandler.sharedHandler.getImage(instance: self, rect: nil, completion: {
                    image in
                    self.insertImage(image: image, atIndex: index)
                    self.checkNextButton()
                })
            }
        }
    }
    
    func checkNextButton() {
        if self.allImagesUploaded() {
            self.btnNext.isButtonActive = true
            self.lblTakePhotos.text = "Photos successfully uploaded".localize()
        }
        else {
            self.btnNext.isButtonActive = false
            self.lblTakePhotos.text = "Take the photos of your documents".localize()
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        if let bankInfoVC = DIConfigurator.sharedInst().getBankInfoVC() {
            bankInfoVC.sellerType = .individual
//            bankInfoVC.arrayImages.append(contentsOf: self.getImages())
            bankInfoVC.arrayDocuments = self.arrayDocuments
            self.navigationController?.pushViewController(bankInfoVC, animated: true)
        }
    }
}

extension IndividualUploadDocsViewC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UploadDocumentsCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        let data = dataSource[indexPath.row]
        let image = data["documentImage"] as? UIImage
        if let placeholderImage = data["placeholderImage"] as? UIImage, let description = data["description"] as? String {
            cell.configureView(image: image, placeholderImage: placeholderImage, description: description, data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectImage(index: indexPath.row)
    }
}

extension IndividualUploadDocsViewC: UploadDocumentsCellDelegate {
    func didTapUploadDoc(_ cell: UploadDocumentsCell) {
        guard let indexPath = self.tblViewDocs.indexPath(for: cell) else { return }
        self.selectImage(index: indexPath.row)
    }
    
    func didTapCancel(_ cell: UploadDocumentsCell) {
        guard let indexPath = self.tblViewDocs.indexPath(for: cell) else { return }
        self.removeImage(atIndex: indexPath.row)
        self.checkNextButton()
    }
}
