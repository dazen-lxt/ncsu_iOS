//
//  AzureStorage.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import CoreData
import AZSClient

class AzureStorage: StorageProtocol {
    var managedObjectContext: NSManagedObjectContext?
    var results: [PhotoInfo] = []
    var isSetup: Bool = false
    var isLoading: Bool = false
    
    var azureContainers: [AZSCloudBlobContainer] = []
    let connectionStrings = [
        "SharedAccessSignature=sv=2019-12-12&ss=bfqt&srt=sco&sp=rwdlacupx&se=2021-03-04T04:26:50Z&st=2020-12-03T20:26:50Z&spr=https&sig=OSokTwa6AE5O%2FGWEnj9Eptld%2B4KIwKlZom%2BfJfD3J%2F8%3D;BlobEndpoint=https://weedsapp.blob.core.windows.net",
        "SharedAccessSignature=sv=2019-10-10&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-03-04T08:45:02Z&st=2020-12-04T00:45:02Z&spr=https&sig=O2ud3EFHplFGlU2lPX6AOVVlu8lpYhYImbbs%2Bo6LQ98%3D;BlobEndpoint=https://weedsmedia.blob.core.usgovcloudapi.net"
    ]
    
    func setup() {
        do {
            azureContainers = try connectionStrings.map {
                let blobClient = try AZSCloudStorageAccount(fromConnectionString:$0).getBlobClient()
                return blobClient.containerReference(fromName: "images")
            }
            isSetup = true
            continueWithUpload()
        } catch {
            isLoading = false
            //Inform error
            print(error)
        }
    }
    
    func uploadPhoto(photoInfo: PhotoInfo, json: String) {
        azureContainers.forEach { (azureContainer) in
            var jsonUploaded = false
            var dataUploaded = false
            let blobInfo = azureContainer.blockBlobReference(fromName: "\(photoInfo.name ?? "").info")
            blobInfo.upload(fromText: json, completionHandler: { err in
                if(err == nil) {
                    jsonUploaded = true
                    if(jsonUploaded && dataUploaded) {
                        print("Ok with \(photoInfo.name ?? "")")
                    }
                }
            })
            let blob = azureContainer.blockBlobReference(fromName: "\(photoInfo.name ?? "").jpg")
            blob.upload(from: photoInfo.photo!, completionHandler: { err in
                if(err == nil) {
                    dataUploaded = true
                    if(jsonUploaded && dataUploaded) {
                        print("Ok with \(photoInfo.name ?? "")")
                    }
                }
            })
        }
    }
    
    
}

