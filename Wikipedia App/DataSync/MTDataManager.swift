//
//  MTDataManager.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 28/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit

class MTDataManager: NSObject {

    static let sharedInstance = MTDataManager()
    
    func getBaseUrlFromUserDefaults() -> String {
        return (UserDefaults.standard.value(forKey: "BASEURL") as? String) ?? kBaseUrl_English
    }
    
    func setBaseUrlFromUserDefaults(url: String) {
        UserDefaults.standard.set(url, forKey: "BASEURL")
    }
    
    
    func getSearchKeywordFromUserDefaults() -> String {
        return (UserDefaults.standard.value(forKey: "SEARCH_KEYWORD") as? String) ?? ""
    }
    
    func setSearchKeywordFromUserDefaults(keyword: String) {
        UserDefaults.standard.set(keyword, forKey: "SEARCH_KEYWORD")
    }
    
}

