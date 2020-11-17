//
//  UITableView+Reusable.swift
//  WeedAI
//
//  Created by Carlos Muñoz on 10/19/20.
//  Copyright © 2020 Carlos Muñoz. All rights reserved.
//

import UIKit

extension UITableView {
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }

        return cell
    }
    
    func register<T: UITableViewCell>(_: T.Type) {
        let nib = UINib(nibName: T.defaultReuseIdentifier, bundle: nil)
                register(nib, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
}
