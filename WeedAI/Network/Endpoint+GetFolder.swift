//
//  Endpoint+GetFolder.swift
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
    public struct GetFolder {
        var name: String
    }
}

/**
 EndpointProtocol implementation in payment struct.
 */
extension Endpoint.GetFolder: EndpointProtocol {

    public var path: String { return "drive/v3/files" }
    public var method: Alamofire.HTTPMethod { return .get }

   public var queryItems: [URLQueryItem]? {
        return [URLQueryItem(
            name: "q",
            value: "name='\(name)' and mimeType = 'application/vnd.google-apps.folder'"
            )]
    }
}

