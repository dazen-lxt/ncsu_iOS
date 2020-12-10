//
//  CreateDriveResponse.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 12/4/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

struct FileDriveResponse: Decodable, Encodable {
    var id: String?
}

struct ListDriveResponse: Decodable, Encodable {
    var files: [FileDriveResponse]?
}
