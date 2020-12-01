
//
//  WeatherType.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/24/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

enum WeatherType: Int {
    case SUNNY = 0, PARTIAL, CLOUDY
    
    func getStringValue() -> String {
        switch self {
        case .SUNNY:
            return "SUNNY"
        case .PARTIAL:
            return "PARTIAL"
        case .CLOUDY:
            return "CLOUDY"
        }
    }
    
    static func getFromStringValue(value: String) -> WeatherType {
        switch value {
        case "SUNNY":
            return .SUNNY
        case "PARTIAL":
            return .PARTIAL
        default:
            return .CLOUDY
        }
    }
}
