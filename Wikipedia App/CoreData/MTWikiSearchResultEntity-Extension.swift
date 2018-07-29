//
//  MTWikiSearchResultEntity-Extension.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import CoreData

extension MTWikiSearchResultEntity {
    
    
    class func addNewRecord(item: MTSearchResult, context: NSManagedObjectContext)
    {
        
        let searchResultObject = NSEntityDescription.insertNewObject(forEntityName: kMTWikiSearchResultEntity, into: context) as! MTWikiSearchResultEntity
        
        searchResultObject.title = item.Title
        searchResultObject.index = item.Index ?? 0
        searchResultObject.desc = item.Description
        searchResultObject.thumbnail = item.Thumbnail
        searchResultObject.pageId = item.PageId ?? 0
    }
    
    
    class func fetchAllRecords(context: NSManagedObjectContext) -> [MTWikiSearchResultEntity]? {
        
        let allrecords = try? context.fetchRecordsForEntity("MTWikiSearchResultEntity")        
        return allrecords as? [MTWikiSearchResultEntity]
    }
    
}
