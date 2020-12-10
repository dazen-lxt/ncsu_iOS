//
//  CoreData.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    func getPhotos(managedObjectContext: NSManagedObjectContext) -> [PhotoInfo] {
        do {
            let fetchRequest : NSFetchRequest<PhotoInfo> = PhotoInfo.fetchRequest()
            let results = try managedObjectContext.fetch(fetchRequest)
            return results as [PhotoInfo]
        } catch {
            return []
        }
    }
    
    func updateSynchPhoto(managedObjectContext: NSManagedObjectContext, photoInfo: PhotoInfo) {
        do {
            photoInfo.synced = true
            try managedObjectContext.save()
        } catch let error {
            print(error)
        }
    }
    
}
