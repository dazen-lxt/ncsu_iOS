
//
//  Double+format.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 11/25/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import Foundation

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
