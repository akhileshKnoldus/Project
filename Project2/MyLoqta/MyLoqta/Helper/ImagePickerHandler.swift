//
//  ImagePickerHandler.swift
//  MyLoqta
//
//  Created by Shivansh Jaitly on 7/5/18.
//  Copyright © 2018 AppVenturez. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

class ImagePickerHandler: NSObject
{
    static let sharedHandler = ImagePickerHandler()
    var guestInstance: UIViewController? = nil
    var imageClosure: ((UIImage)->())? = nil
    var imgInfoClosure: (([String: Any])->())? = nil
    
    // Public Methods
    
    func getImage(instance: UIViewController, rect: CGRect?, allowEditing: Bool? = true , completion: ((_ myImage: UIImage)->())?)
    {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = allowEditing ?? true
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionSelectCamera = UIAlertAction(title: "Camera".localize(), style: .default, handler: {
            UIAlertAction in
            self.openCamera(picker: imgPicker)
        })
        let actionSelectGallery = UIAlertAction(title: "Gallery".localize(), style: .default, handler: {
            UIAlertAction in
            self.openGallery(picker: imgPicker)
            
        })
        let actionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionSelectCamera)
        actionSheet.addAction(actionSelectGallery)
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.guestInstance?.present(actionSheet, animated: true, completion: nil)
        }
        else if rect != nil
        {
            actionSheet.popoverPresentationController?.sourceView = guestInstance?.view
            actionSheet.popoverPresentationController?.sourceRect = rect!
            actionSheet.popoverPresentationController?.permittedArrowDirections = .any
            self.guestInstance?.present(actionSheet, animated: true, completion: nil)
        }
        imageClosure = {
            (image) in
            completion?(image)
        }
        
    }
    
    func getImageDict(instance: UIViewController, rect: CGRect?, completion: ((_ imgDict: [String: Any])->())?)
    {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        let actionSheet = UIAlertController(title: "Select Image".localize(), message: "Choose an option".localize(), preferredStyle: .actionSheet)
        let actionSelectCamera = UIAlertAction(title: "Camera".localize(), style: .default, handler: {
            UIAlertAction in
            self.openCamera(picker: imgPicker)
        })
        let actionSelectGallery = UIAlertAction(title: "Gallery".localize(), style: .default, handler: {
            UIAlertAction in
            self.openGallery(picker: imgPicker)
            
        })
        let actionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionSelectCamera)
        actionSheet.addAction(actionSelectGallery)
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            self.guestInstance?.present(actionSheet, animated: true, completion: nil)
        }
        else
        {
            actionSheet.popoverPresentationController?.sourceView = guestInstance?.view
            actionSheet.popoverPresentationController?.sourceRect = rect!
            actionSheet.popoverPresentationController?.permittedArrowDirections = .up
            self.guestInstance?.present(actionSheet, animated: true, completion: nil)
        }
        
        imgInfoClosure = {
            dictInfo in
            completion?(dictInfo)
        }
    }
    
    func getImage(instance: UIViewController,isSourceCamera: Bool,completion: ((_ myImage: UIImage)->())?)
    {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        if isSourceCamera
        {
            self.openCamera(picker: imgPicker)
        }
        else
        {
            self.openGallery(picker: imgPicker)
        }
        imageClosure = {
            (image) in
            completion?(image)
        }
    }
    
    func getImageDict(instance: UIViewController,isSourceCamera:Bool,rect: CGRect?, completion: ((_ imgDict: [String: Any])->())?)
    {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.mediaTypes = [(kUTTypeImage) as String]
        if isSourceCamera
        {
            self.openCamera(picker: imgPicker)
        }
        else
        {
            self.openGallery(picker: imgPicker)
        }
        
        imgInfoClosure = {
            dictInfo in
            completion?(dictInfo)
        }
    }
    
    func getImageOrVideo(instance: UIViewController, rect: CGRect?, completion: ((_ imgDict: [String: Any])->())?)
    {
        guestInstance = instance
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        imgPicker.mediaTypes = [(kUTTypeImage) as String,(kUTTypeMovie) as String]
        imgPicker.videoMaximumDuration = 60
        imgPicker.videoQuality = UIImagePickerControllerQualityType.typeMedium
        let actionSheet = UIAlertController(title: "Select Image".localize(), message: "Choose an option".localize(), preferredStyle: .actionSheet)
        let actionSelectCamera = UIAlertAction(title: "Camera".localize(), style: .default, handler: {
            UIAlertAction in
            self.openCamera(picker: imgPicker)
        })
        let actionSelectGallery = UIAlertAction(title: "Gallery".localize(), style: .default, handler: {
            UIAlertAction in
            self.openGallery(picker: imgPicker)
            
        })
        let actionCancel = UIAlertAction(title: "Cancel".localize(), style: .cancel, handler: nil)
        actionSheet.addAction(actionCancel)
        actionSheet.addAction(actionSelectCamera)
        actionSheet.addAction(actionSelectGallery)
        
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            Threads.performTaskInMainQueue {
                self.guestInstance?.present(actionSheet, animated: true, completion: nil)
            }
        }
        else if rect != nil
        {
            actionSheet.popoverPresentationController?.sourceView = guestInstance?.view
            actionSheet.popoverPresentationController?.sourceRect = rect!
            actionSheet.popoverPresentationController?.permittedArrowDirections = .any
            Threads.performTaskInMainQueue {
                self.guestInstance?.present(actionSheet, animated: true, completion: nil)
            }
        }
        imgInfoClosure = {
            dictInfo in
            completion?(dictInfo)
        }
    }
    
    //Private Methods
    
    private func openCamera(picker: UIImagePickerController)
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.edgesForExtendedLayout = UIRectEdge.all
            picker.showsCameraControls = true
            self.guestInstance?.present(picker, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Warning".localize(), message: "Camera is not available".localize(), preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "Ok".localize(), style: .default, handler: nil)
            alert.addAction(actionOK)
            self.guestInstance?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openGallery(picker: UIImagePickerController)
    {
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.guestInstance?.present(picker, animated: true, completion: nil)
    }
}

//MARK: - UIImagePicker Delegates
extension ImagePickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) //Cancel button  of imagePicker
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) //Picking Action of ImagePicker
    {
        picker.dismiss(animated: true, completion: nil)
        imgInfoClosure?(info)
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageClosure?(img)
        }
    }
}

