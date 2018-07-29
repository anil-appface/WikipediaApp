//
//  MTNetworkHelper.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MTNetworkHelper: NSObject {

    class func requestGETURL(_ strURL: String, paramters: [String: String]?, showLoader : Bool = false ,success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        //Show loader
        if let topController = UIApplication.topViewController(), showLoader {
            topController.showLoader()
        }
        
        Alamofire.request(strURL, parameters: paramters).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            //Hide loader
            if let topController = UIApplication.topViewController(), showLoader {
                topController.hideLoader()
            }
            
            
            if responseObject.result.isSuccess {
                
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                
                if let topController = UIApplication.topViewController() {
                    topController.showAlert(title: "Money Tap", message: error.localizedDescription)
                }
                
                failure(error)
            }
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                
                if let topController = UIApplication.topViewController() {
                    topController.showAlert(title: "Money Tap", message: error.localizedDescription)
                }
                
                failure(error)
            }
        }
    }
    
}
