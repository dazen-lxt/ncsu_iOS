//
//  SensorType.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/21/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

enum SensorType: Int {
    case ACCELEROTEMER = 0, GYROSCOPE, MAGNETOMETER, PRESSURE
    static func allRawValues() -> [Int] {
        return [SensorType.ACCELEROTEMER.rawValue,
                SensorType.GYROSCOPE.rawValue,
                SensorType.MAGNETOMETER.rawValue,
                SensorType.PRESSURE.rawValue]
    }
    static func allValues() -> [SensorType] {
        return [.ACCELEROTEMER,
                .GYROSCOPE,
                .MAGNETOMETER,
                .PRESSURE]
    }
}
