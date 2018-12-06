//
//  APIManager.swift
//  AV
//

import Alamofire
//import AlamofireImage
import SwiftyUserDefaults
import ReachabilitySwift
import DataCache


class APIManager: Alamofire.SessionManager {
    
    internal static let shared: APIManager = {
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 60
        return APIManager()
    }()
    
    var arrOfHitsAPI = [[String: Any]]()
    var requestCache = [String: RequestCaching]()
    var requestDic = [String: DataRequest]()
    var successAlertCallBack: (() -> Void)?
    
    //var imageDownloader: ImageDownloader? = ImageDownloader(configuration: ImageDownloader.defaultURLSessionConfiguration(), downloadPrioritization: .lifo, maximumActiveDownloads: 4, imageCache: AutoPurgingImageCache())
    
    //MARK: - Request
    func request(apiRouter: APIRouter, completionHandler: @escaping (_ responseData: Any, _ success: Bool) -> Void) {
        
        let key = getUniqueForRequest(apiRouter)
        if Loader.isReachabile() == false {
            
            Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: ConstantTextsApi.noInternetConnection.localizedString)
            /*
            if apiRouter.supportOffline, let data = DataCache.instance.readData(forKey: key) {
                do {
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                    if let reponse = json, let result = reponse[kResult] {
                        completionHandler(result, true)
                    }
                } catch {
                    print("error")
                }
            } else {
//                TAAlert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: ConstantTexts.noInternetConnection.localizedString)
            }*/
            return
        } //Return if found no network or use cache value
        if apiRouter.showLoader == true { Loader.showLoader() } //Start loader
        
        Threads.performTaskAfterDealy(0.1) {
            
            if !apiRouter.path.isEmpty {
                Debug.Log(message: "🔴 MyLoqta Request => \(apiRouter.baseUrl)/\(apiRouter.path) : \(String(describing: apiRouter.parameters)) ☄️")
            }
            
            // Create Key
            
            let requestCaching = RequestCaching(apiRouter: apiRouter, completionHandler: completionHandler)
            self.requestCache[key] = requestCaching
            
            
            // Send request to server
            let req = self.request(apiRouter).responseJSON { (responseData: DataResponse<Any>) in
                
                self.requestDic.removeValue(forKey: key) // Removed excuted request
                
                Debug.Log(message: "response: \(responseData)")
                if let url = responseData.request?.url {
                    if let data = responseData.result.value as? [String:AnyObject] {
                        Debug.Log(message: "🔴Response Of => \(url) =>\n \(data) ☄️")
                    }
                }
                
                if responseData.response == nil {
                    if apiRouter.supportOffline, let data = DataCache.instance.readData(forKey: key) {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                            if let reponse = json, let result = reponse[kResult] {
                                completionHandler(result, true)
                            }
                        } catch {
                            print("error")
                        }
                    } else {
                        completionHandler([String: AnyObject](), false)
                        Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: ConstantTextsApi.serverNotResponding.localizedString)
                    }
                    
                    if apiRouter.showLoader == true { // Hide loader
                        Loader.hideLoader()
                    }
                    return
                }
                
                var dataObject = [String: AnyObject]()
                if let responseData = responseData.result.value as? [String:AnyObject] {
                    dataObject = responseData
                } else if let responseData = responseData.result.value {
                    dataObject = ["response": responseData as AnyObject]
                }
                
                if let success = dataObject[kSuccess] as? Bool, success == true {
                    self.removeHoldAPIRequestApi(apiRouter.path)
                    if let result = dataObject[kResult] {
                        if apiRouter.fullResponse {
                            completionHandler(dataObject, success)
                        } else {
                            completionHandler(result, success)
                        }
                        
                    } else {
                        completionHandler([:], success)
                    }
                    
                    if apiRouter.showMessageOnSuccess, let msg = dataObject[kMessage] as? String {
                        //Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: msg)
                        Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: msg, completeion_: { _ in
                            if let completion = self.successAlertCallBack  {
                                completion()
                            }
                        })
                    }
                    
                    if apiRouter.supportOffline, let data = responseData.data {
                        DataCache.instance.write(data: data, forKey: key)
                    }
                    
                    //DataCache.instance.write(data: dataObject, forKey: key)
                    
                } else {
                    
                    if let msg = dataObject[kMessage] as? String {
                        
                        if let errorCode = dataObject["Status"] as? Int, errorCode == 210 {
                            Loader.hideLoader()
                            Alert.showOkAlertWithCallBack(title: ConstantTextsApi.AppName.localizedString, message: msg, completeion_: { _ in                                
                                 AppDelegate.delegate.logout()
                            })
                            return
                        } else if let errorCode = dataObject["errorCode"] as? Int, errorCode == 403 || errorCode == 401 {
                            self.holdAPIRequestApi(apiRouter: apiRouter, completionClosure: completionHandler)
                            if let expiresIn = Defaults[.expiresIn] {
                                let jwtToken = JWTToken.sharedHandler.createJWTToken(userId: AppDelegate.delegate.getUserId(), expiry: Double(expiresIn))
                                Defaults[.jwtToken] = jwtToken
                                self.reHitHoldAPI()
                            }
                        }  else {
                            if apiRouter.showAlert {
                                Alert.showOkAlert(title: ConstantTextsApi.AppName.localizedString, message: msg)
                            }
                        }
                        
                        if apiRouter.fullResponse {
                            completionHandler(dataObject, false)
                        } else {
                            completionHandler([:], false)
                        }
                    }
//                    return
                }
                
                if apiRouter.showLoader == true { // Hide loader
                    Loader.hideLoader()
                }
            }
            
            // Save request
            self.requestDic[key] = req
        }
    }
    
    
    func holdAPIRequestApi(apiRouter: APIRouter, completionClosure:  @escaping (_ responseData: Any, _ success: Bool) -> Void){
        
        var holdDic = [String:Any]()
        holdDic["apiRouter"] = apiRouter
        holdDic["callBack"] = completionClosure
        arrOfHitsAPI.append(holdDic)
    }
    
    func reHitHoldAPI(){
        for holdDic in arrOfHitsAPI {
            guard let apirouter = holdDic["apiRouter"] as? APIRouter,
                let completionClosure = holdDic["callBack"] as? (Any, Bool)->(Void)  else{ continue}
            
            self.request(apiRouter: apirouter, completionHandler: completionClosure)
        }
    }
    
    func removeHoldAPIRequestApi(_ serviceName: String){
        let index = arrOfHitsAPI.index { (holdDic) -> Bool in
            guard let apiRouter = holdDic["apiRouter"] as? APIRouter, apiRouter.path == serviceName  else{return false}
            return true
        }
        if let tempIdex = index, tempIdex < arrOfHitsAPI.count{
            arrOfHitsAPI.remove(at: tempIdex)
        }
    }
    
    func cancelAllRequests() {
        requestCache.removeAll()
        let allKeys = requestDic.keys
        for key in allKeys {
            if let safeRequest = requestDic[key] {
                safeRequest.cancel()
                requestDic.removeValue(forKey: key)
            }
        }
        // Clear request dic
        requestDic.removeAll()
    }
    
    func dataObject(response: DataResponse<Any>) -> [String: AnyObject] {
        var data = [String: AnyObject]()
        if let dataDict = response.result.value as? [String: AnyObject] {
            data = dataDict
        }
        else if let dataArr = response.result.value as? [AnyObject] {
            data = ["response": dataArr as AnyObject]
        }
        return data
    }
    
    func onError(message: String, success: Bool, dataObject: [String: AnyObject], errorCode: Int, showAlert: Bool,  completionHandler: @escaping ([String: AnyObject], Bool) -> ()) {
        
        if !showAlert {
            completionHandler(dataObject, success)
            return
        }
        let target = Helper.topMostViewController(rootViewController: Helper.rootViewController())
        if errorCode != 0 {
            
           // Alert.showAlert(message, okButtonTitle: ConstantTexts.cancel.localized, target: target)
        }
        completionHandler(dataObject, success)
    }

    
    func getUniqueForRequest(_ apiRouter: APIRouter) -> String {
        var key = "\(apiRouter.baseUrl)/\(apiRouter.path)"
        for (k,v) in Array(apiRouter.parameters).sorted(by: {$0.0 < $1.0}) {
            key.append(k)
            key.append("\(v)")
        }
        key = key.replacingOccurrences(of: "//", with: "_")
        key = key.replacingOccurrences(of: "/", with: "_")
        key = key.replacingOccurrences(of: ",", with: "_")
        key = key.replacingOccurrences(of: "@", with: "_")
        key = key.replacingOccurrences(of: ":", with: "_")
        key = key.replacingOccurrences(of: ".", with: "_")
        return key
    }
    
    
    func handleError(_ responseData: [String: AnyObject]){
        
    }
    
    private class func handleProgress(
        progress: CGFloat,
        completionProgress: @escaping(_ progress: CGFloat) -> Void) {
        completionProgress(progress)
    }
}

struct ApiMessages {
    
    static let NoInternetConnection = ConstantTextsApi.noInternetConnection.localizedString
    static let Connecting = ConstantTextsApi.connecting.localizedString
    static let APIResponseError  = ConstantTextsApi.errorOccurred.localizedString
    
    /*
    static func APIResponseError(statusCode: Int?, errorCode: Int) -> String {
        let statusCode = statusCode != nil ? String(statusCode!) :ConstantTexts.None.localizedString
        return " \(ApiMessages.APIResponseError)\n \(ConstantTexts.InternalCode.localized): \(errorCode)\n\(ConstantTexts.StatusCode.localized): \(statusCode)"
    }*/
}

struct RequestCaching {
    var apiRouter: APIRouter
    var completionHandler: ((_ responseData: [String: AnyObject], _ success: Bool) -> Void)?
}

