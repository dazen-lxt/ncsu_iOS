//
//  Endpoint.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation
import Alamofire

public protocol EndpointProtocol: URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var params: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var queryItems: [URLQueryItem]? {get}
    var authorized: Bool {get}
}


extension EndpointProtocol {

    public var authorized: Bool {
        return true
    }

    public var baseURL: URL {
        return URL(string: "https://www.googleapis.com/")!
    }

    func encode(_ urlRequest: URLRequestConvertible) throws -> URLRequest {
        return try encoding.encode(urlRequest, with: params)
    }

    public func asURLRequest() throws -> URLRequest {
        var urlComponent = URLComponents(string: baseURL.appendingPathComponent(path).absoluteString)!
        urlComponent.queryItems = queryItems
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.httpMethod = method.rawValue
        if let headers = headers {
            urlRequest.headers = headers
        }
        headers?.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.name) }
        if authorized {
            urlRequest.setValue("Bearer \(GoogleManager.shared.token ?? "")", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest = try encode(urlRequest)
        return urlRequest
    }

    public var queryItems: [URLQueryItem]? {
        return nil
    }

    public var headers: HTTPHeaders? {
        return [
        "Content-Type": "application/json"
        ]
    }

    public var encoding: ParameterEncoding {
        return Alamofire.JSONEncoding.default
    }

    public var params: Parameters? {
        return nil
    }
}

public struct Endpoint {}
