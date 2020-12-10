//
//  Endpoint+CreateDriveFolder.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import Alamofire

extension Endpoint {
    /**
     Struct for defer
     */
    public struct CreateDriveFolder {
        var name: String
    }
}

/**
 EndpointProtocol implementation in payment struct.
 */
extension Endpoint.CreateDriveFolder: EndpointProtocol {

    public var path: String { return "drive/v3/files" }
    public var method: Alamofire.HTTPMethod { return .post }

    public var params: Parameters? {
        return
            [
                "name": name,
                "mimeType": "application/vnd.google-apps.folder"
        ]
    }
}
