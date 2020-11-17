//
//  WeedNumber.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/28/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

enum WeedNumber: Int {
    case ONE = 0, TWO_FIVE, MORE_FIVE
    
    func getStringValue() -> String {
        switch self {
        case .ONE:
            return "1"
        case .TWO_FIVE:
            return "2-5"
        case .MORE_FIVE:
            return ">5"
        }
    }
}
