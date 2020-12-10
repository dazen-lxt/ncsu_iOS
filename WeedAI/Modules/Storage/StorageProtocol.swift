//
//  StorageProtocol.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import CoreData

protocol StorageProtocol: class {
    
    var isLoading: Bool { get set }
    
    var managedObjectContext: NSManagedObjectContext? { get set }
    
    var isSetup: Bool { get set }
    
    var results: [PhotoInfo] { get set }
    
    func uploadImages(managedObjectContext: NSManagedObjectContext)
    
    func uploadPhoto(photoInfo: PhotoInfo, json: String)
    
    func setup()
    
    func continueWithUpload()
    
    func photoSynch(photoInfo: PhotoInfo)
}

extension StorageProtocol {
    
    
    func uploadImages(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        if(isLoading || GoogleManager.shared.token == nil) { return }
        isLoading = true
        self.results = CoreDataManager.shared.getPhotos(managedObjectContext: managedObjectContext)
        if(!isSetup) {
            setup()
        } else {
            continueWithUpload()
        }
        
    }
    
    func continueWithUpload() {
        do {
            for photoInfo in results where photoInfo.photo != nil {
                let data = PhotoInfoModelData(name: photoInfo.name ?? "", description: photoInfo.photoDescription ?? "", weather: photoInfo.weather ?? "", weedType: photoInfo.typeWeed ?? "", weedsAmount: photoInfo.weedsAmount ?? "", latitude: "\(photoInfo.latitude)", longitude: "\(photoInfo.longitude)", email: GoogleManager.shared.email ?? "", sensors: (photoInfo.sensors?.allObjects as? [SensorInfo] ?? []).map { SensorModelData(name: $0.sensorName ?? "", unit: $0.units ?? "", values: ($0.values?.allObjects as? [SensorValue] ?? []).map { sensorValue in "\(sensorValue.value)" } ) })
                let jsonEncoder = JSONEncoder()
                let jsonData = try jsonEncoder.encode(data)
                let json = String(data: jsonData, encoding: String.Encoding.utf8)
                uploadPhoto(photoInfo: photoInfo, json: json ?? "")
                //Upload Synced
            }
        } catch {
            isLoading = false
        }
    }
    
    func photoSynch(photoInfo: PhotoInfo) {
        if let managedObjectContext = managedObjectContext {
            CoreDataManager.shared.updateSynchPhoto(managedObjectContext: managedObjectContext, photoInfo: photoInfo)
            for photoInfo in results {
                if photoInfo.synced == false {
                    return
                }
            }
            isLoading = false
        }
    }
}
