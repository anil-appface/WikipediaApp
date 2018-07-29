//
//  MTSyncEngine.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON

class MTSyncEngine: NSObject {

    var baseUrl: String!
    // Create singleton object.
    fileprivate static var privateShared : MTSyncEngine?
    
    class var sharedInstance: MTSyncEngine {
        guard let uwShared = privateShared else {
            privateShared = MTSyncEngine()
            return privateShared!
        }
        return uwShared
    }
    
    
    //MARK: Network calls
    func getWikiSearchResults(forSearchString query: String)  {
        
        var parameters = getRequestParams(forItem: .listUrl)
        parameters["gpssearch"] = query
        
        MTNetworkHelper.requestGETURL(baseUrl,  paramters:  parameters ,success: { [weak self](response) in
            
            //print(response)
            
            self?.parseAndSaveToCoreData(response: response)
            
        }) { (error) in
            
            //Handle error
        }
    }
    
    func getWikiSearchDetailUrl(forPageId pageId: String, completionHandler: @escaping (String?)->()) {
        
        var parameters = getRequestParams(forItem: .detailUrl)
        parameters["pageids"] = pageId
        
        MTNetworkHelper.requestGETURL(baseUrl,  paramters:  parameters, showLoader: true ,success: { (response) in

            if let detailsUrl = response["query"]["pages"][pageId]["fullurl"].string {
                completionHandler(detailsUrl)
            } else {
                completionHandler(nil)
            }
            
        }) { (error) in
            
            //Handle error
        }
    }
    
    //MARK: Save to core data.
    func parseAndSaveToCoreData(response:JSON) {
        
        
        let managedObjectContext = appDelegate.coreDataManager.managedObjectContext
        
        //Delete all records in MTWikiSearchResultEntity
        managedObjectContext.deleteAllRecordsForEntity(kMTWikiSearchResultEntity)
        
        appDelegate.coreDataManager.saveChanges()
        
        //Parse data.
        if let allResultArray = response["query"]["pages"].array {
            
            let privateManagedObject = NSManagedObjectContext.init(concurrencyType: .privateQueueConcurrencyType)
            privateManagedObject.parent = managedObjectContext
            
            privateManagedObject.perform {
                
                for searchRecord in allResultArray {
                    
                    var mtSearchResult = MTSearchResult()
                    
                    mtSearchResult.Title = searchRecord["title"].string
                    mtSearchResult.Index = searchRecord["index"].int64
                    mtSearchResult.PageId = searchRecord["pageid"].int64
                    mtSearchResult.Thumbnail = searchRecord["thumbnail"]["source"].string
                    mtSearchResult.Description = searchRecord["terms"]["description"].array?[0].string
                    
                    MTWikiSearchResultEntity.addNewRecord(item: mtSearchResult, context: privateManagedObject)
                }

                try? privateManagedObject.save()
                
                appDelegate.coreDataManager.saveChanges()
            }
            

        } else {
            //print error
        }
        
        
    }
}


extension MTSyncEngine {
    
    fileprivate func getRequestParams(forItem item: WikiPediaApi) -> [String: String]{
        
        var getParamDict = [String: String]()
        
        switch item {
        case .listUrl:
            getParamDict["action"] = "query"
            getParamDict["formatversion"] = "2"
            getParamDict["generator"] = "prefixsearch"
            getParamDict["gpslimit"] = "50"
            getParamDict["prop"] = "pageimages|pageterms"
            getParamDict["piprop"] = "thumbnail"
            getParamDict["pithumbsize"] = "50"
            getParamDict["pilimit"] = "10"
            getParamDict["wbptterms"] = "description"
            getParamDict["redirects"] = ""
            getParamDict["format"] = "json"
        case .detailUrl:
            
            getParamDict["action"] = "query"
            getParamDict["prop"] = "info"
            getParamDict["inprop"] = "url"
            getParamDict["format"] = "json"
            
        }
        
       
        
   
        
        return getParamDict
        
    }
    
}
