//
//  TAS3Manager.swift
//  OneNation
//
//  Created by Ashish Chauhan on 01/12/17.
//  Copyright © 2017 Ashish Chauhan. All rights reserved.
//

import Foundation
import UIKit
import AWSCore
import AWSS3

enum UploadReqType {
    case displayPic
    case coverPic
    case other
}

let s3bucketFolder = "S3Bucket"
let bucketName = "appinventiv-development"

typealias progressBlock = (_ totalByteSend: user_long_t, _ totoalByteExpectedToSend: user_long_t, _ isFinished: Bool) -> Void
typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void

class TAS3Manager {
    
    static let sharedInst = TAS3Manager()
    
    init() {
        //self.createS3Folder()
    }
    
    var uploadProgress:((_ totalByteSend: user_long_t, _ totoalByteExpectedToSend: user_long_t, _ isFinished: Bool) -> Void)?
    var responseBlock:((_ response: Any?, _ error: Error?) -> Void)?
    var uploadReqCoverPic: AWSS3TransferManagerUploadRequest?
    var uploadReqDisplayPic: AWSS3TransferManagerUploadRequest?
    
    
    func createS3Folder() {
        let fileManager = FileManager.default
        if let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            var filePath =  docDirectory.appendingPathComponent("\(s3bucketFolder)")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                    try fileManager.addSkipBackupAttributeToItemAtURL(url: &filePath)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            }
            NSLog("Document directory is \(filePath)")
        }
    }
    
    func getS3FolderPath() -> URL? {
        
        let fileManager = FileManager.default
        if let docDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  docDirectory.appendingPathComponent("\(s3bucketFolder)")
            return filePath
        } else {
            return nil
        }
    }
    
    func getFilePath(_ fileName: String) -> String {
        if let s3FolderPath = self.getS3FolderPath() {
            let filePath = s3FolderPath.appendingPathComponent(fileName)
            return filePath.path
        } else {
            return ""
        }
    }
    
    func uploadImage(_ image: UIImage, _ uploadType: UploadReqType, _ progress: progressBlock?, _ response: completionBlock?) {
        let uploadReq = self.uploadImage(image.manageOrientation(maxResolution: 1024.0)!, progress, response)
        switch uploadType {
        case .displayPic:
            self.uploadReqDisplayPic = uploadReq
        case .coverPic:
            self.uploadReqCoverPic = uploadReq
        default:
            break
        }
    }
    
    func cancelCoverPicUpload() {
        if let upload = self.uploadReqCoverPic {
            upload.cancel()
        }
    }
    
    func cancelDisplayPicUpload() {
        if let upload = self.uploadReqDisplayPic {
            upload.cancel()
        }
    }
    
    func cancelAllUpload() {
        let transferManager = AWSS3TransferManager.default()
        transferManager.cancelAll()
    }
    
    private func uploadImage(_ image: UIImage, _ progress: progressBlock?, _ response: completionBlock?) -> AWSS3TransferManagerUploadRequest?  {
        
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".png")
        let filePath: String = self.getFilePath(fileName)
        if let imageData = UIImagePNGRepresentation(image) {
            do {
                try imageData.write(to: URL(fileURLWithPath: filePath))
                if let uploadRequest = AWSS3TransferManagerUploadRequest() {
                    uploadRequest.body = URL(fileURLWithPath: filePath)
                    uploadRequest.key = fileName
                    uploadRequest.contentType = "image"
                    uploadRequest.bucket = bucketName
                    self.uploadReqeust(uploadRequest, uploadProgress: progress, completion: response)
                    return uploadRequest
                }
            } catch {
                // Handle exception here
            }
        }
        return nil
    }
    
    
    func uploadVideo(_ urlVideo: URL, _ progress: progressBlock?, _ response: completionBlock?) {
        let strExt: String = "." + (URL(fileURLWithPath: urlVideo.absoluteString).pathExtension)
        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (strExt)
        if let uploadRequest = AWSS3TransferManagerUploadRequest() {
            uploadRequest.body = urlVideo
            uploadRequest.key = fileName
            uploadRequest.contentType = "video"
            uploadRequest.bucket = bucketName
            self.uploadReqeust(uploadRequest, uploadProgress: progress, completion: response)
        }
    }

    func uploadReqeust(_ uploadRequest: AWSS3TransferManagerUploadRequest, uploadProgress: progressBlock?, completion responseBlock: completionBlock?) {
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { (task: AWSTask) -> Any? in
            
            if let error = task.error {
                print("Upload failed with error: (\(error.localizedDescription))")
                if responseBlock != nil {
                    responseBlock!(nil, error)
                }
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                print("Uploaded to:\(String(describing: publicURL))")
                if responseBlock != nil {
                    responseBlock!(publicURL?.absoluteString, nil)
                }
            }
            return nil
        }
        
        if let progress = uploadProgress {
            switch uploadRequest.state {
            
            case .running:
                uploadRequest.uploadProgress = {(_ bytesSent: Int64, _ totalBytesSent: Int64, _ totalBytesExpectedToSend: Int64) -> Void in
                    DispatchQueue.main.async(execute: {() -> Void in
                        if totalBytesExpectedToSend > 0 {
                            progress(user_long_t(totalBytesSent),user_long_t(totalBytesExpectedToSend), false)
                        }
                    })
                }
            case .notStarted: break
            case .paused: break
            case .canceling: break
            case .completed: break
            }
        }
    }
    
}

extension FileManager{
    
    func addSkipBackupAttributeToItemAtURL( url:inout URL) throws {
        var resourceValues = URLResourceValues()
        resourceValues.isExcludedFromBackup = true
        try url.setResourceValues(resourceValues)
    }
}
