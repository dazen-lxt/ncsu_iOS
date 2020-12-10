//
//  Endpoint+UploadFile.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/5/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import Alamofire

extension Endpoint {
    /**
     Struct for defer
     */
    public struct UploadFile {
    }
}

/**
 EndpointProtocol implementation in payment struct.
 */
extension Endpoint.UploadFile: EndpointProtocol {

    public var path: String { return "upload/drive/v3/files" }
    public var method: Alamofire.HTTPMethod { return .post }

    public var headers: HTTPHeaders? {
        return [
        "Content-Type": "multipart/form-data"
        ]
    }
    
    public var queryItems: [URLQueryItem]? {
        return [URLQueryItem(
            name: "uploadType",
            value: "multipart"
        )]
    }
}

