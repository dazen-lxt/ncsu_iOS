
//
//  ConditionManager.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/24/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

class ConditionManager {
    
    static let shared = ConditionManager()
    
    private init() {}
    
    var weatherType: WeatherType = .SUNNY
    var weedType = ""
    
}
