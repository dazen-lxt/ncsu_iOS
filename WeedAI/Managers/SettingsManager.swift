//
//  SettingsManager.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/21/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

class SettingsManager {
    
    static let shared = SettingsManager()
    
    private init() {}
    
    func checkIfUseAzureStorage() -> Bool {
        if let useAzure = UserDefaults.standard.object(forKey: UserDefaultKeys.useAzure) as? Bool {
            return useAzure
        } else {
            UserDefaults.standard.set(true, forKey: UserDefaultKeys.useAzure)
            return true
        }
    }
    
    func saveStorageMethod(isAzure: Bool) {
        UserDefaults.standard.setValue(isAzure, forKey: UserDefaultKeys.useAzure)
    }
    
    func getSensors() -> [SensorType] {
        if let sensors = UserDefaults.standard.object(forKey: UserDefaultKeys.sensors) as? [Int] {
            return sensors.map { SensorType(rawValue: $0) ?? SensorType.ACCELEROTEMER }
        } else {
            UserDefaults.standard.set(SensorType.allRawValues(), forKey: UserDefaultKeys.sensors)
            return SensorType.allValues()
        }
    }
    
    func saveSensors(_ sensors: [Int]) {
        UserDefaults.standard.setValue(sensors, forKey: UserDefaultKeys.sensors)
    }
    
}
