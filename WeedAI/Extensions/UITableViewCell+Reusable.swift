//
//  UITableViewCell+Reusable.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

extension UITableViewCell {

    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
