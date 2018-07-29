//
//  NSManagedObjectContext-Extension.swift
//  Wikipedia App
//
//  Created by Anil Kumar on 27/07/18.
//  Copyright © 2018 Anil Kumar. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObjectContext {

    func fetchRecordsForEntity(_ entity: String) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        
        // Helpers
        var result = [NSManagedObject]()
        
        do {
            // Execute Fetch Request
            let records = try self.fetch(fetchRequest)
            
            if let records = records as? [NSManagedObject] {
                result = records
            }
            
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }

    
    func deleteAllRecordsForEntity(_ entity: String) {
        // Create Fetch Request
//        do {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            try self.execute(batchDeleteRequest)
//            self.reset()
//        } catch {
//            print(error)
//        }

        let allRecords = fetchRecordsForEntity(entity)
        allRecords.forEach { (managedObject) in
            self.delete(managedObject)
        }
    
    }

    
}


