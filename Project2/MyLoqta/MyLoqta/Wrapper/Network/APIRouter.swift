//
//  APIRouter.swift
//  AV
//

import UIKit
import Alamofire
import SwiftyUserDefaults

public typealias JSONDictionary = [String: AnyObject]
typealias APIParams = [String: AnyObject]

struct APIRouter: URLRequestConvertible {
    
    var endpoint: APIEndpoint
    var detail: APIDetail
    init(endpoint: APIEndpoint) {
        
        self.endpoint = endpoint
        self.detail = APIDetail.init(endpoint: endpoint)
    }
    
    var baseUrl: String {
        
        return APIEnvironment.Base.rawValue
    }
    
    var method: Alamofire.HTTPMethod {
        
        return detail.method
    }
    
    var path: String {
        
        return detail.path
    }
    
    var parameters: APIParams {
        
        return detail.parameter
    }
    
    var encoding: ParameterEncoding? {
        
        return detail.encoding
    }
    
    var showAlert: Bool {
        
        return detail.showAlert
    }
    
    var showMessageOnSuccess: Bool {
        
        return detail.showMessageOnSuccess
        
    }
    
    var showLoader: Bool {
        
        return detail.showLoader
    }
    
    var supportOffline: Bool {
        
        return detail.supportOffline
    }
    
    var isBaseUrlNeedToAppend: Bool {
        
        return detail.isBaseUrlNeedToAppend
    }
    
    var isHeaderTokenRequired: Bool {
        return detail.isHeaderTokenRequired
    }
    
    var isUserIdInHeaderRequired: Bool {
        return detail.isUserIdInHeaderRequired
    }
    
    var fullResponse: Bool {
        return detail.fullResponse
    }

    var isAuthenticationRequired: Bool {
        
        switch endpoint {
            
        case .signup(_):
            return false
            
        default:
            return true
        }
    }

    /// Returns a URL request or throws if an `Error` was encountered.
    /// - throws: An `Error` if the underlying `URLRequest` is `nil`.
    /// - returns: A URL request.
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: baseUrl)
        
        var urlRequest = URLRequest(url: isBaseUrlNeedToAppend ? (url?.appendingPathComponent(self.path))! : URL(string: self.path)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = 60
        if let token = Defaults[.jwtToken], isHeaderTokenRequired {
            //urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            print("the token is --->",token)
            
            urlRequest.setValue(token, forHTTPHeaderField:KHeaderToken)
        }
        
        if isUserIdInHeaderRequired {
            let userId = UserSession.sharedSession.getUserId()
            urlRequest.setValue("\(userId)", forHTTPHeaderField:KUserId)
        }
        
//        application/x-www-form-urlencoded
//        "Content-Type"
        
        //urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        return try encoding!.encode(urlRequest, with: self.parameters)
    }
}
