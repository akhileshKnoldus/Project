//
//  CloudinaryManager.swift
//  SymCloudinary
//
//  Created by Ashish Chauhan on 11/03/18.
//  Copyright © 2018 Ashish Chauhan. All rights reserved.
//

import Foundation
import UIKit
import Cloudinary

class CloudinaryManager {
    
    static let manager = CloudinaryManager()
    let apiKey = "147992964421448"
    let cloudName = "sylab"
    let uploadPreset = "nnxuq08p"
    let cloudinary: CLDCloudinary!
    
    init() {
        print("cloudinary manager initialize ++++++++++++++++++ =================")
        let config = CLDConfiguration(cloudName: cloudName, apiKey: apiKey, apiSecret: nil)
        cloudinary = CLDCloudinary(configuration: config)
    }
    
    /// Upload single image to Cloudinary server
    ///
    /// - Parameters:
    ///   - image: UIImage to upload on server
    ///   - progress: image upload progress, Double value
    ///   - completion: image upload finish
    func uploadImage(image: UIImage, progress: ((_ uploadProgress: Double) ->Void)?, completion: @escaping (_ url: String, _ error: Error?) -> Void) {
        if Loader.isReachabile() == false {
            Alert.showOkAlert(title: ConstantTextsApi.AppName.rawValue, message: ConstantTextsApi.noInternetConnectionTryAgain.localizedString)
            return
        }
        if let data = UIImageJPEGRepresentation(image, 0.7) {
            cloudinary.createUploader().upload(data: data, uploadPreset: uploadPreset, params: nil, progress: { (prog) in
                guard progress != nil else { return }
                progress!(prog.fractionCompleted)
            }) { (result, error) in
                if error == nil, let imageUrl = result?.url {
                    completion(imageUrl, nil)
                } else {
                    print("error is: \(String(describing: error?.localizedDescription))")
                    completion("", error)
                }
            }
        }
    }
    
    func uploadFile(_ fileUrl: URL, completion: @escaping (_ url: String, _ error: Error?) -> Void) {
        cloudinary.createUploader().upload(url: fileUrl, uploadPreset: uploadPreset, params: nil, progress: nil) { (result, error) in
            if error == nil, let fileUrl = result?.url {
                completion(fileUrl, nil)
            } else {
                print("error is: \(String(describing: error?.localizedDescription))")
                completion("", error)
            }
        }
    }

}
