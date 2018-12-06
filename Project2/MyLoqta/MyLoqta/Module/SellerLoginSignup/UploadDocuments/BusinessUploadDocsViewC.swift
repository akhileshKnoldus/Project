//
//  BusinessUploadDocsViewC.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/4/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import UIKit

class BusinessUploadDocsViewC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblUploadDocs: UILabel!
    @IBOutlet weak var lblUploadDocsDesc: UILabel!
    @IBOutlet weak var tblViewDocs: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnNext: AVButton!
    
    //MARK: - Variables
    var viewModel: BusinessUploadDocsVModeling?
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
            self.viewModel = BusinessUploadDocsVM()
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
        self.uploadImage(index: atIndex, image: image)
    }
    
    
    private func removeImage(atIndex: Int) {
        var data = self.dataSource[atIndex]
        data["documentImage"] = nil
        data["imageUrl"] = ""
        data[Constant.keys.kImageStatus] = ImageStatus.empty
        self.dataSource[atIndex] = data
        self.tblViewDocs.reloadData()
    }
    
    private func allImagesUploaded() -> Bool {
        for data in self.dataSource {
            if let imageUrl = data["imageUrl"] as? String, imageUrl == "" {
                return false
            }
        }
        return true
    }
    
    private func uploadImage(index: Int, image: UIImage) {
        //Loader.showLoader()
        TAS3Manager.sharedInst.uploadImage(image, .other, nil) {[weak self] (response, error) in
            //Loader.hideLoader()
            guard let strongSelf = self else { return }
            if let imageUrl = response as? String {
                var data = strongSelf.dataSource[index]
                data["imageUrl"] = imageUrl
                data[Constant.keys.kImageStatus] = ImageStatus.uploaded
                strongSelf.dataSource[index] = data
                strongSelf.addToDocumentsArray(index: index, imageUrl: imageUrl)
                print("array is: \(strongSelf.dataSource)")
            } else {
                var data = strongSelf.dataSource[index]
                data[Constant.keys.kImageStatus] = ImageStatus.uploadFailed
                strongSelf.dataSource[index] = data
            }
            
            Threads.performTaskInMainQueue {
                strongSelf.tblViewDocs.reloadData()
                strongSelf.checkNextButton()
            }
        }
    }
    
    private func addToDocumentsArray(index: Int, imageUrl: String) {
        let dict = ["title": index + 1 as AnyObject, "url": imageUrl as AnyObject]
        self.arrayDocuments.append(dict)
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
            self.lblUploadDocs.text = "Photos successfully uploaded".localize()
        }
        else {
            self.btnNext.isButtonActive = false
            self.lblUploadDocs.text = "Upload your documents".localize()
        }
    }
    
    //MARK: - IBActions
    @IBAction func tapBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapNext(_ sender: UIButton) {
        if let bankInfoVC = DIConfigurator.sharedInst().getBankInfoVC() {
            bankInfoVC.sellerType = .business
//            bankInfoVC.arrayImages.append(contentsOf: self.getImages())
            bankInfoVC.arrayDocuments = self.arrayDocuments
            self.navigationController?.pushViewController(bankInfoVC, animated: true)
        }
    }
}

extension BusinessUploadDocsViewC: UITableViewDataSource, UITableViewDelegate {
    
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

extension BusinessUploadDocsViewC: UploadDocumentsCellDelegate {
    
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
