//
//  APIConfiguration.swift
//  AV
//


import Foundation
import Alamofire

let resultsPerPageOfAVline = 25

let kStatus = "Status"
let kToken = "token"
let kSuccess = "Success"
let kMessage = "Message"
let kResult = "Result"
let kErrorCode = "ErrorCode"
let kAuthToken = "token"
let kCreatedOn = "createdOn"
let kExpiresIn = "expiresIn"
let kData = "data"
let KHeaderToken = "token"

enum APIEnvironment: String {
    
    case Base = "http://appinventive.com:8130" // Development
//    case Base = "http://appinventive.com:8194" // Staging

    case socketUrl = "http://appinventive.com:7237"  //Development
    
}

enum ConstantTextsApi: String {
    
    case noInternetConnection = "No Internet Connection"
    case noInternetConnectionTryAgain = "No Internet Connection. Please try again."
    case connecting =  "connecting"
    case errorOccurred          =  "ErrorOccurred"
    //case AppName = "MyLoqta"//The Don
    case AppName = "myLoqta"
    case serverNotResponding =  "Server is not responding."
    case cancel = "Cancel"
    
    var localizedString:String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}



