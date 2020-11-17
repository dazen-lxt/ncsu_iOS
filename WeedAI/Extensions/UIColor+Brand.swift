//
//  UIColor+Brand.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

extension UIColor {
    enum Brand {
        static var primaryColor = UIColor(named: "PrimaryColor") ?? UIColor.black
        static var outlineGrayColor = UIColor(named: "OutlineGrayColor") ?? UIColor.black
        static var lightGrayColor = UIColor(named: "LightGrayColor") ?? UIColor.black
        static var darkGrayColor = UIColor(named: "DarkGrayColor") ?? UIColor.black
    }
}
