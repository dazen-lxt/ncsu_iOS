//
//  DriveStorage.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import CoreData
import AZSClient
import Alamofire

class DriveStorage: StorageProtocol {
    var managedObjectContext: NSManagedObjectContext?
    var results: [PhotoInfo] = []
    var isSetup: Bool = false
    var isLoading: Bool = false
    var folderId: String?
    let folderName = "WeedAI"
    
    func setup() {
        if(folderId == nil) {
            let request = Endpoint.GetFolder(name: folderName)
            AF.request(request).responseDecodable(of: ListDriveResponse.self) { [weak self] (response) in
                switch(response.result) {
                case .success(let value):
                    if let firstFolder = value.files?.first {
                        self?.folderId = firstFolder.id
                        self?.isSetup = true
                        self?.continueWithUpload()
                    } else {
                        self?.createFolder()
                    }
                    return
                case .failure(let error):
                    print(error)
                }
                self?.isLoading = false
                //Inform error
            }
            
    
        } else {
            isSetup = true
            continueWithUpload()
        }
    }
    
    func createFolder() {
        let request = Endpoint.CreateDriveFolder(name: folderName)
        AF.request(request).responseDecodable(of: FileDriveResponse.self) { [weak self] (response) in
            switch(response.result) {
            case .success(let value):
                if let id = value.id {
                    self?.folderId = id
                    self?.isSetup = true
                    self?.continueWithUpload()
                    return
                }
            case .failure(let error):
                print(error)
            }
            self?.isLoading = false
            //Inform error
        }
    }
    
    
    func uploadPhoto(photoInfo: PhotoInfo, json: String) {
        var jsonUploaded = false
        var dataUploaded = false
        let request = Endpoint.UploadFile()
        let jsonEncoder = JSONEncoder()
        let jsonImage = MetadataModel(name: "\(photoInfo.name ?? "").jpg", parents: [folderId ?? ""])
        guard let jsonImageData = try? jsonEncoder.encode(jsonImage) else { return }
        let jsonSensorFile = MetadataModel(name: "\(photoInfo.name ?? "").json", parents: [folderId ?? ""])
        guard let jsonSensorFileData = try? jsonEncoder.encode(jsonSensorFile) else { return }
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(jsonImageData, withName: photoInfo.name ?? "", mimeType: "application/json")
            if let data = photoInfo.photo {
                multipartFormData.append(data, withName: photoInfo.name ?? "", fileName: "\(photoInfo.name ?? "").jpg", mimeType: "image/png")
            }
        }, with: request)
        .responseDecodable(of: FileDriveResponse.self) { [weak self] (response) in
            if case .success(_) = response.result {
                dataUploaded = true
                if(jsonUploaded && dataUploaded) {
                    self?.photoSynch(photoInfo: photoInfo)
                }
            }
        }
        AF.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(jsonSensorFileData, withName: photoInfo.name ?? "", mimeType: "application/json")
            if let data = json.data(using: String.Encoding.utf8) {
                multipartFormData.append(data, withName: photoInfo.name ?? "", fileName: "\(photoInfo.name ?? "").json", mimeType: "text/plain")
            }
        }, with: request)
        .responseDecodable(of: FileDriveResponse.self) { [weak self] (response) in
            if case .success(_) = response.result {
                jsonUploaded = true
                if(jsonUploaded && dataUploaded) {
                    self?.photoSynch(photoInfo: photoInfo)
                }
            }
        }
    }
    
}
