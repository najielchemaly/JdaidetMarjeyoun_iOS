//
//  Services.swift
//  Ste-Louise
//
//  Created by MR.CHEMALY on 4/10/17.
//  Copyright © 2017 MR.CHEMALY. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ServiceName {
    
    static let getGlobalVariables = "/getGlobalVariables"
    
}

enum ResponseStatus: Int {
    
    case SUCCESS = 1
    case FAILURE = 0
    case CONNECTION_TIMEOUT = -1
    
}

enum ResponseMessage: String {
    
    case SERVER_UNREACHABLE = "An error has occured, please try again."
    case CONNECTION_TIMEOUT = "Check your internet connection."
    
}

class ResponseData {
    
    var status: Int = ResponseStatus.SUCCESS.rawValue
    var message: String = String()
    var json: [NSDictionary]? = [NSDictionary]()
    var jsonObject: JSON? = JSON((Any).self)
    
}

class Services {
    
    private let BaseUrl = "192.168.0.107/Api"
    private let Suffix = ""
    private let ACCESS_TOKEN = UserDefaults.standard.string(forKey: Keys.AccessToken.rawValue)
    
    func getConfig() -> ResponseData? {
        
        return makeHttpRequest(method: .get, serviceName: ServiceName.getGlobalVariables)
    }
    
    // MARK: /************* SERVER REQUEST *************/

   private func makeHttpRequest(method: HTTPMethod, serviceName: String, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) -> ResponseData {
    
        let response = Alamofire.request(BaseUrl + Suffix + serviceName, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(options: .allowFragments)
        let responseData = ResponseData()
        responseData.status = ResponseStatus.FAILURE.rawValue
        responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
        if let token = response.response?.allHeaderFields[Keys.AccessToken.rawValue] as? String{
            UserDefaults.standard.set(token, forKey: Keys.AccessToken.rawValue)
        }
        if let jsonArray = response.result.value as? [NSDictionary] {
            let json = jsonArray.first
            if let status = json!["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json!["message"] as? String {
                responseData.message = message
            }
            if let message = json!["message"] as? Bool {
                responseData.message = String(message)
            }
            
            if let json = jsonArray.last {
                responseData.json = [json]
            }
            
        } else if let json = response.result.value as? NSDictionary {
            if let status = json["status"] as? Int {
                let boolStatus = status == 1 ? true : false
                switch boolStatus {
                case true:
                    responseData.status = ResponseStatus.SUCCESS.rawValue
                    break
                default:
                    responseData.status = ResponseStatus.FAILURE.rawValue
                    break
                }
            }
            if let message = json["message"] as? String {
                responseData.message = message
            }
            if let message = json["message"] as? Bool {
                responseData.message = String(message)
            }
            
            responseData.json = [json]
            
        } else if let jsonArray = response.result.value as? NSArray {
            if let jsonStatus = jsonArray.firstObject as? NSDictionary {
                if let status = jsonStatus["status"] as? Int {
                    responseData.status = status
                }
            }
            
            if let jsonData = jsonArray.lastObject as? NSArray {
                responseData.json = [NSDictionary]()
                for jsonObject in jsonData {
                    if let json = jsonObject as? NSDictionary {
                        responseData.json?.append(json)
                    }
                }
            }
        } else {
            responseData.status = ResponseStatus.FAILURE.rawValue
            responseData.message = ResponseMessage.SERVER_UNREACHABLE.rawValue
            responseData.json = nil
        }
        
        return responseData
    
    }
    
    let manager: SessionManager = {
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        return SessionManager(configuration: configuration)
        
    }()
    
    func getBaseUrl() -> String {
        return self.BaseUrl
    }
}
