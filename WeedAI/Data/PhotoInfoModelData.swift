//
//  PhotoInfoModelData.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/10/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

struct PhotoInfoModelData: Codable {
    var name: String
    var description: String
    var weather: String
    var weedType: String
    var weedsAmount: String
    var latitude: String
    var longitude: String
    var email: String
    var sensors: [SensorModelData]
}

struct SensorModelData: Codable {
    var name: String
    var unit: String
    var values: [String]
}
